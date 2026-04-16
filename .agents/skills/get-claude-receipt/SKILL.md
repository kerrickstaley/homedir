---
name: get-claude-receipt
description: Download the latest Claude.ai subscription receipt PDF into the current working directory
---
Run `./download_latest_receipt.py` (from this skill's directory) to fetch the most recent Claude.ai subscription receipt and save it to the user's CWD as `Claude Subscription <date> - <total>.pdf`.

The script drives the user's real Chrome via `playwright-cli attach --extension=chrome` (Playwright MCP Bridge extension), so it reuses the existing claude.ai login. Prerequisites:
- `playwright-cli` on PATH
- The "Playwright MCP Bridge" Chrome extension installed and activated
- User already signed in to claude.ai in that Chrome profile

The script logs the found download and elapsed time to stderr. If it fails because the extension isn't attached, ask the user to click the extension icon in Chrome to share a tab, then retry.

The first time you run the script, it may fail because PLAYWRIGHT_MCP_EXTENSION_TOKEN is not set. First, tell the user to make sure that the Playwright MCP Bridge extension is installed in Chrome from https://chromewebstore.google.com/detail/playwright-mcp-bridge/mmlmfjhmonkocbjadbfplnigmagldckm , and then tell you it's installed. After they tell you it's installed, determine which shell the user uses, and then re-run the script and ask the user to paste the PLAYWRIGHT_MCP_EXTENSION_TOKEN to you from their browser, explaining that you will add it to their .rc file. Then do that and temporarily run the script setting the env var on the command line (because the .rc file change might not take effect until the user opens a new shell).
