---
name: bootstrap
description: Ground opencode in a repo that lacks agentic scaffolding. Use at the start of a project, or when a repo has no AGENTS.md, ROADMAP.md, or docs/adr. Surveys the repo, writes the project AGENTS.md, seeds ROADMAP.md, and initializes docs/adr/.
---

# Project Bootstrap Protocol

Give opencode the structural scaffolding it needs to stay grounded.

## 1. Survey Repository
- Inspect manifest files (`package.json`, `pyproject.toml`, `Cargo.toml`, `CMakeLists.txt`, etc.), lockfiles, and active dependencies.
- Inspect `git status`, `git branch`, and `git log --oneline -10`.
- Identify top-level layout, existing documentation, and diagnostic commands (lint, typecheck, test, build).

## 2. Write Project `AGENTS.md`
Create `AGENTS.md` at project root containing **project facts only**:
- Project purpose & tech stack.
- Package manager & build tools.
- Diagnostic commands (`lint`, `typecheck`, `test`, `build`).
- Repository conventions, design patterns (if any) & gotchas (if any).
*(Workflow rules belong in global AGENTS.md, not here).*

## 3. Seed `ROADMAP.md`
Create `ROADMAP.md` at project root using this exact template:

```md
# Repository Roadmap

## Macro Plan
- **Current Milestone:** [Short Milestone Description]
- **Goal:** [2-3 sentences on overall macro project direction]

---

## Active Card
> *There can only be ONE Active card at a time. Finish or push to Next before opening another.*

### [Card Title: Short Verb Phrase]
- **Intent:** [2 lines explaining what is being built/replaced and why]
- **Trade-offs / Risks:** [1-2 bullets on architectural trade-offs or technical constraints]
- **Acceptance Criteria (DoD):**
  - [ ] [Example 1: Observable behavior check e.g., `npm test auth` passes]
  - [ ] [Example 2: Observable CLI / API / Smoke test check]
  ...
- **Out of Scope:** [Explicit boundaries on forbidden refactors, extra abstractions, or unrequested features]

---

## Next Cards
> *Direction-only one-liners for future work in this milestone.*

- **[Card Title]:** [1-line intent]
...

---

## Done Cards
> *Completed cards with objective outcomes.*

*(None yet)*
```

## 4. Initialize `docs/adr/`

- Create directory `docs/adr/`.
- Create `docs/adr/0000-index.md` containing a simple markdown list for tracking future ADRs.

## Confirm

- Show the user the seeded files and ask them to confirm or trim the Next cards before implementation starts.
