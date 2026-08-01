---
description: Verify the current task, then propose a commit
agent: build
---
Finish the current task:

1. Restate the task's behavior and blast radius (files in scope).
2. If the task has observable behavior and no boundary check exists yet, write a tiny check first and see it fail (RED). Pure internal refactors can skip.
3. Run the project's diagnostics (from project AGENTS.md) plus the boundary check. Fix failures from their output only — hypothesize, isolate, fix, re-verify. If a fix fails twice, `git restore`/`git checkout` the failing change and retry clean.
4. When green, `git add` the relevant files and show `git status` + a `git diff --staged` summary.
5. Propose a conventional commit message and ASK me to approve. Do not commit without approval.
6. If this completes a milestone/card, also propose moving it to Done in ROADMAP.md.
