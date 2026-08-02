---
name: adr
description: Consult and maintain Architecture Decision Records under docs/adr/. Use before architecture-affecting work, new dependencies, data model changes, or design pattern choices.
---

# Architecture Decision Record (ADR) Protocol

Maintain concise, lightweight decision logs under `docs/adr/`.

## 1. Consult Phase (Index-First Reading)
- **Always read `docs/adr/0000-index.md` FIRST.** Do not glob or read all individual ADR files upfront.
- Read specific record files (`docs/adr/NNNN-*.md`) **only if** the index indicates a title directly affects the active task.
- Respect `Status: Superseded by NNNN` — read the superseding record instead.

## 2. Trigger Criteria (Create When)
Draft a new ADR **only** when work introduces:
- A new external dependency (or removing one).
- Data model or public API contract changes.
- Selecting a design pattern that alters system boundaries.

## 3. Location & Naming
- File path: `docs/adr/NNNN-short-hyphenated-title.md`
- `NNNN` = incremental integer padded to 4 digits (e.g., `0001`, `0002`).

## 4. Record Template (Keep under 30 lines)

```md
# NNNN. Title

- **Status:** Proposed | Accepted | Superseded by NNNN
- **Date:** YYYY-MM-DD

## Context
[1-2 paragraphs max: What problem or requirement forces this decision?]

## Decision
[2-3 sentences max: Chosen approach and key implementation boundary.]

## Consequences
- **Positive:** [Key benefit]
- **Negative/Risks:** [Main trade-off or tech debt introduced]

```

## 5. Index Maintenance Protocol

Whenever creating or updating an ADR, update `docs/adr/0000-index.md`:

* If `docs/adr/0000-index.md` does not exist, create it with a markdown table containing columns: `Number`, `Title`, `Status`, `Date`.
* **On New ADR:** Append a new row to `0000-index.md` linking to the record.
* **On Status Change:** Update the status column in `0000-index.md` (e.g., `Proposed` → `Accepted` or `Superseded by NNNN`).
