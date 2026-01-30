# General
Be succinct. When writing code, only comment when necessary and aim to write terse code that is still readable.

# Python
- Use single quotes instead of double quotes.
- Make all function arguments required, unless the user will want to use the default value most of the time.
- Most of my Python projects use uv. When trying to run code in a project, assume it uses uv and only fall back to the system python3 interpreter if uv does not work.
- Use Plotly, not Matplotlib, for making graphs.
- Use Polars, not Pandas, for doing data analysis.

# Git
- When creating a worktree, make it under the wt/ directory in the root of the main repo (not as a sibling to the main repo).
