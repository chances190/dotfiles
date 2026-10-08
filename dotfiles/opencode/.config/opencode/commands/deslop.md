---
description: "Ruthless de-slop pass over the repository (usage: /deslop [scope], or /deslop)"
agent: deslop
subagent: true
---
Run a de-slop pass over $ARGUMENTS. If no scope is given, review the current state of the repository, recent commits, uncommitted working-tree changes versus HEAD — staged, unstaged, and untracked files. Work in dependency order, keep the build and tests green, and commit nothing: leave every change in the working tree for human review. Report what you changed, what you deliberately did not touch, and why.
