---
name: edit-pdf
description: Instructions for filling out and editing PDFs
---
When asked to fill out a PDF, after you are done, double-check that all the fields you filled in are correctly aligned, and re-generate if not. Also make sure that the text size is appropriate and the signature (if any) is appropriately sized.

When editing a PDF, I suggest using pypdf, reportlab, and pdfplumber. You can use them with
```
uv run --with pypdf --with reportlab --with pdfplumber python3 << 'PYEOF'
...
PYEOF
```
