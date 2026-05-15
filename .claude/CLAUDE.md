# General
- Be succinct. When writing code, only comment when necessary and aim to write terse code that is still readable.
- Avoid the "be liberal in what you accept" part of Postel's law for internal APIs. Code should crash loudly if input is malformed. We want to avoid covering up mistakes in other LLM-written code in the same codebase. An exception is that if you are writing an API that is likely to be used more by a human than by an agent (e.g. a CLI), you should be more liberal in what you accept.
- If the user explicitly asks you to send them a notification, run "notify your message here" in Bash.

# Python
- IMPORTANT: I usually use `uv`, not the system Python interpreter. When trying to run Python code in a project, always try uv first. Only try the system python3 interpreter if uv does not work.
- Make all function arguments required, unless the user will want to use the default value most of the time.
- Use Plotly, not Matplotlib, for making graphs.
- Use Polars, not Pandas, for doing data analysis.
- When I ask you to "write a script with a shebang", the shebang should be "#!/usr/bin/env -S uv run python" and you should chmod the file +x.
- When I ask you to run logging.basicConfig, you should call logging.basicConfig(format='%(asctime)s %(levelname)s %(name)s: %(message)s', datefmt='%Y-%m-%d %H:%M:%S', level=logging.INFO)
- When I ask you to make a notebook, you should create a .py file using Jupytext-style # %% comments to separate cells, not a .ipynb file.
- In Polars when using groupby(...).agg(...), if you expect there to be a single value for some column across the whole group, use pl.col(...).unique().item(), not pl.col(...).first().
- In a notebook, when I say to use tqdm, do `from tqdm.autonotebook import tqdm`.

# Git
- All repos (for both my projects and others' projects) are under ~/src.
- When creating a worktree, make it under the wt/ directory in the root of the main repo (not as a sibling to the main repo).
- My fork of a repo will use "fork" as the remote name.

# Misc
- I often dictate prompts and there may be typoes especially for sound-alike words.
- If you need to access the user's Google account, prefer the `gws` CLI utility over the GMail or Google Calendar MCP. Only use the latter MCP servers if you try `gws` and it does not work (e.g. due to network sandboxing).
