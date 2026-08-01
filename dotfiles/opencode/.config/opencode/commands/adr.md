---
description: Create or consult Architecture Decision Records (usage: /adr new "Title", or /adr)
agent: plan
---
Use the `adr` skill:

- If $ARGUMENTS starts with "new": create `docs/adr/NNNN-short-title.md` for the given title, following the template. Show me the record and ask before committing.
- Otherwise: survey `docs/adr/`, summarize the decisions affecting the current work, and note anything superseded.
- Cross-cutting changes always require my sign-off before implementation.
