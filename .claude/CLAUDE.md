# General
- Be succinct. When writing code, only comment when necessary and aim to write terse code that is still readable.
- If the user explicitly asks you to send them a notification, run "notify your message here" in Bash.

# Python
- IMPORTANT: I usually use `uv`, not the system Python interpreter. When trying to run Python code in a project, always try uv first. Only try the system python3 interpreter if uv does not work.
- Use single quotes instead of double quotes for new code, but match the style of existing code.
- Make all function arguments required, unless the user will want to use the default value most of the time.
- Use Plotly, not Matplotlib, for making graphs.
- Use Polars, not Pandas, for doing data analysis.
- When I ask you to "write a script with a shebang", the shebang should be "#!/usr/bin/env -S uv run python" and you should chmod the file +x.
- When I ask you to run logging.basicConfig, you should call logging.basicConfig(format='%(asctime)s %(levelname)s %(name)s: %(message)s', datefmt='%Y-%m-%d %H:%M:%S', level=logging.INFO)
- When I ask you to make a notebook, you should create a .py file using Jupytext-style # %% comments to separate cells, not a .ipynb file.
- In Polars when using groupby(...).agg(...), if you expect there to be a single value for some column across the whole group, use pl.col(...).unique().item(), not pl.col(...).first().

# Git
- All repos (for both my projects and others' projects) are under ~/src.
- When creating a worktree, make it under the wt/ directory in the root of the main repo (not as a sibling to the main repo).
- My fork of a repo will use "fork" as the remote name.

# Vibe Kanban
- When I tell you to give me the VSCode link and you running inside Vibe Kanban (i.e. the CWD is under /var/tmp/vibe-kanban/), print a link like vscode://vscode-remote/ssh-remote+<current host IP>/var/tmp/vibe-kanban/worktrees/<rest of path to repo>?windowId=_blank.
