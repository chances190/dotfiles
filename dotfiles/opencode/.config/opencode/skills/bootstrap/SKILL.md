---
name: bootstrap
description: Ground opencode in a repo that lacks agentic scaffolding. Use at the start of a project, or when a repo has no AGENTS.md, ROADMAP.md, or docs/adr. Surveys the repo, writes the project AGENTS.md, seeds ROADMAP.md, and initializes docs/adr/.
---

# Project bootstrap

Give opencode the files it needs to stay grounded in a repo.

## Survey

- Manifest files (package.json / pyproject.toml / CMakeLists.txt / Cargo.toml …), lockfiles, stack.
- `git status` and `git log --oneline -10`; note the current branch.
- Top-level structure; existing docs, specs, or rules.

## Write project AGENTS.md

General description of the project's purpose + Stack + package manager + every diagnostic command that exists (lint, typecheck, test, build) + repo conventions + gotchas. Keep it project facts only — workflow rules live in the global AGENTS.md.

## Seed ROADMAP.md

- `## Macro Plan` from the user's stated goal (ask if none is given).
- `## Active` — the current card with Intent, Acceptance Criteria (DoD), and Out of Scope (empty if starting fresh).
- `## Done` — objective one-liners for work that already landed.
- `## Next` — abstract, direction-only one-liners.
- Roadmap only — no task lists, no mental notes. Active work lives in the todo tool + git.

## Initialize docs/adr/

- Create `docs/adr/` and an index file (`README.md` or `0000-index.md`) if missing.
- Do not invent ADRs; the `adr` skill creates them on demand.

## Confirm

- Show the user the seeded files and ask them to confirm or trim the Next cards before implementation starts.
