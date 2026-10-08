---
name: adr
description: Consult and maintain Architecture Decision Records under docs/adr/. Use before architecture-affecting work, new dependencies, data model changes, or design pattern choices.
---

# Architecture Decision Record (ADR) Protocol

Maintain concise, machine-readable architecture decision logs under `docs/adr/`.

## 1. Trigger Criteria

**Create an ADR ONLY when a decision:**
* Introduces a hard-to-reverse external dependency (e.g., database engine, primary framework).
* Alters public API contracts or data models in a backward-incompatible way.
* Fundamentally changes system boundaries or paradigms (e.g., REST to event-driven architecture).

**Do NOT create an ADR for:**
* Routine implementation details (e.g., standard HTTP clients, utility choices).
* Minor refactoring or file restructures.
* Tactical, short-term, or easily reversible decisions.

## 2. Consultation Protocol

1. **Read `docs/adr/README.md` first.** This index contains only active records (`Proposed` or `Accepted`).
2. **Fetch specific files only when relevant.** Read individual `docs/adr/NNNN-title.md` files only if directly related to your current task.
3. **Avoid globbing `docs/adr/`.** `README.md` is the single source of truth for current decisions; do not scan files upfront.

## 3. Directory Layout

* **Active Records:** `docs/adr/NNNN-title.md` (where `NNNN` is a zero-padded 4-digit ID).
* **Archived Records:** `docs/adr/superseded/NNNN-title.md`.
* **Active Index:** `docs/adr/README.md`.

## 4. Record Template

Every ADR must include YAML frontmatter followed by a brief body (≤30 lines total).

```markdown
---
id: NNNN
title: short-hyphenated-title
status: Proposed          # Proposed | Accepted | Superseded
date: YYYY-MM-DD
supersedes: []            # Optional: [NNNN]
superseded_by: null       # Optional: NNNN
---

# NNNN. Title

## Context
[1-2 paragraphs: Problem or requirement driving this decision]

## Decision
[2-3 sentences: Selected approach, architectural boundaries, and scope]

## Consequences
* **Positive:** [Key advantages]
* **Negative/Risks:** [Trade-offs, technical debt, or operational overhead]
```

## 5. Index Maintenance Protocol

Maintain `docs/adr/README.md` using the following Markdown table structure:

| ID | Title | Status | Date |
|:---|:------|:-------|:-----|

**Rules:**
* **New ADR:** Append row with status `Proposed` or `Accepted`.
* **Status Update:** Update the `Status` column in-place.
* **Supersedure:**
  1. Set frontmatter `status: Superseded` and `superseded_by: <NEW_ID>` on old record.
  2. Move old file to `docs/adr/superseded/NNNN-title.md`.
  3. **Remove** the old ADR row entirely from `docs/adr/README.md`.

## 6. Execution Matrix

| Goal | Action Steps |
|:---|:---|
| **Consult** | Read `docs/adr/README.md` → Read target `docs/adr/NNNN-title.md` if relevant. Never read `superseded/` during routine consultation. |
| **Create** | Verify criteria → Create `docs/adr/NNNN-title.md` with frontmatter → Append row to `docs/adr/README.md`. |
| **Supersede** | Create new ADR (`Accepted`) → Update old ADR frontmatter (`status: Superseded`, `superseded_by`) → Relocate old file to `superseded/` → Remove old row from `README.md`. |
