#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ['platformdirs']
# ///
'''Download the latest Claude subscription receipt and save it to the CWD.

Drives the user's real Chrome via the Playwright MCP Bridge extension, so
the existing claude.ai login is reused. Requires `playwright-cli` on PATH
and the extension installed & activated in Chrome before running.

It's necessary to use Playwright to automate this since Claude for Chrome and
ChatGPT Atlas both refuse to interact with stripe.com URLs (even though the
invoice pages are read-only and harmless).

You should export PLAYWRIGHT_MCP_EXTENSION_TOKEN in ~/.zshrc_local so that this
works automatically. When setting up for the first time, try just running this;
a page will open in Chrome with the token.
'''
import json
import shutil
import subprocess
import sys
import time
from pathlib import Path

from platformdirs import user_downloads_dir

BILLING_URL = 'https://claude.ai/settings/billing'
DOWNLOADS = Path(user_downloads_dir())


def pw(*args, check=True):
    result = subprocess.run(
        ['playwright-cli', *args],
        check=check,
        capture_output=True,
        text=True,
    )
    return result.stdout


def pw_eval(js):
    out = pw('--raw', 'eval', f'() => {{ {js} }}').strip()
    if not out or out == 'undefined':
        return None
    return json.loads(out)


def main():
    start = time.monotonic()
    pw('attach', '--extension=chrome')
    try:
        pw('goto', BILLING_URL)

        # Wait for invoices table and pull first row's data.
        deadline = time.time() + 60
        info = None
        while time.time() < deadline:
            info = pw_eval('''
                const row = document.querySelector('table[aria-label="Invoices"] tbody tr');
                if (!row) return null;
                const cells = row.querySelectorAll('td');
                return {
                    date: cells[0].innerText.trim(),
                    total: cells[1].innerText.trim().split('\\n')[0],
                    url: cells[3].querySelector('a').href,
                };
            ''')
            if info:
                break
            time.sleep(0.5)
        if not info:
            sys.exit('Invoices table did not load')
        print(f'Latest invoice: {info["date"]} {info["total"]}', file=sys.stderr)

        pw('goto', info['url'])

        # Wait for the Download receipt button, snapshot downloads, click it.
        deadline = time.time() + 30
        while time.time() < deadline:
            ready = pw_eval('''
                const btns = [...document.querySelectorAll('button')];
                return btns.some(b => b.innerText.trim() === 'Download receipt');
            ''')
            if ready:
                break
            time.sleep(0.5)
        else:
            sys.exit('Download receipt button never appeared')

        before = {p.name for p in DOWNLOADS.iterdir()}
        pw_eval('''
            const btn = [...document.querySelectorAll('button')]
                .find(b => b.innerText.trim() === 'Download receipt');
            btn.click();
        ''')

        # Poll for a new, fully-downloaded PDF.
        deadline = time.time() + 60
        new_file = None
        while time.time() < deadline:
            current = set(DOWNLOADS.iterdir())
            candidates = [
                p for p in current
                if p.name not in before
                and p.name.startswith('Receipt-')
                and p.suffix == '.pdf'
                and not p.name.endswith('.crdownload')
            ]
            if candidates:
                new_file = max(candidates, key=lambda p: p.stat().st_mtime)
                print(f'Found downloaded receipt: {new_file}', file=sys.stderr)
                break
            time.sleep(0.5)
        if not new_file:
            sys.exit('No PDF appeared in ~/Downloads')

        dest_name = f'Claude Subscription {info["date"]} - {info["total"]}.pdf'
        dest_name = dest_name.replace('/', '_')
        dest = Path.cwd() / dest_name
        shutil.move(new_file, dest)
        print(f"Moved receipt to './{dest.relative_to(Path.cwd())}'", file=sys.stderr)
    finally:
        pw('close', check=False)
        elapsed = time.monotonic() - start
        print(f'Took {elapsed:.1f}s', file=sys.stderr)


if __name__ == '__main__':
    main()
