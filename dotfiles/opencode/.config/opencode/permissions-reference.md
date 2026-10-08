# Command Permission Reference

Single source of truth for opencode agent bash permissions.

## Policy (per sub-agent)

| Agent         | Mutation | Destructive (git-safe) | Destructive |
|---------------|----------|------------------------|-------------|
| **ask**       | deny     | deny                   | deny        |
| **adhoc**     | allow    | ask                    | ask         |
| **coder**     | allow    | allow                  | ask         |
| **architect** | ask      | deny                   | deny        |

## Classification

- **read-only** — reads state only.
- **mutation** — changes state in a temporary, self-contained, or easily reversible way.
- **destructive** — changes state in a hard-to-reverse way OR can lead to any kind of data loss (deleting anything at all, installing into non-self-contained places, moving many things, etc.).
- **destructive (git-safe)** — destructive, but inside a git repo reversible via checkout/reset/stash (deleting files, staging, moving files, stash push, …).
- Building, formatting, installing and running tests are **not** destructive — their effects are regenerable or easily reversible → **mutation**.
- Operations **on git itself** that change repo state and are hard to reverse are destructive, **not** git-safe (commit, merge, rebase, changing upstream, …).
- Not 100% sure about a row? It's flagged in the Notes column — verify before relying on it.

## Rules Matrix

Commands are ordered alphabetically. Subcomands are ordered based on specificity of glob pattern (general before specific). 

Rules match the command as the agent issues it; no command rewriting happens before the permission check.

| Command (glob)                  | Class                  | Notes                                                                                                                                                            |
|---------------------------------|------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `apt *`                         | destructive            | system package manager; installs to non-self-contained locations                                                                                                 |
| `bun build*`                    | mutation               | bundler; regenerable output                                                                                                                                      |
| `bun install*`                  | mutation               | nde_modules is self-contained; lockfile diff reversible via git                                                                                                 |
| `bun run*`                      | mutation               | runs package scripts — impact depends on the script                                                                                                              |
| `bun test*`                     | mutation               | test runner                                                                                                                                                      |
| `cargo build*`                  | mutation               | build output in `target/` (usually gitignored); delete/regenerate to undo                                                                                        |
| `chmod *`                       | mutation               | reversible (chmod back); can break perms/executability if wrong                                                                                                  |
| `chown *`                       | destructive            | needs root to reverse                                                                                                                                            |
| `cp *`                          | destructive (git-safe) | clobbers destination → data loss; git-safe if tracked                                                                                                            |
| `curl*`                         | read-only              | GET/HEAD; mutating `-X`/`--request` forms below                                                                                                                  |
| `curl --request*`               | destructive            | any HTTP method incl. mutations                                                                                                                                  |
| `curl -X DELETE*`               | destructive            |                                                                                                                                                                  |
| `curl -X POST*`                 | destructive            |                                                                                                                                                                  |
| `curl -X PUT*`                  | destructive            |                                                                                                                                                                  |
| `df*`                           | read-only              |                                                                                                                                                                  |
| `docker compose*`               | destructive            | lifecycle mgmt; `down`/`rm -v` removes containers, networks, volumes                                                                                             |
| `docker exec*`                  | mutation               | runs arbitrary cmds in container; state self-contained (recreate to reset)                                                                                       |
| `docker images*`                | read-only              |                                                                                                                                                                  |
| `docker inspect*`               | read-only              |                                                                                                                                                                  |
| `docker logs*`                  | read-only              |                                                                                                                                                                  |
| `docker ps*`                    | read-only              |                                                                                                                                                                  |
| `docker rm*`                    | destructive            | deletes container + write layer; volumes may persist                                                                                                             |
| `docker rmi*`                   | destructive            | deletes image                                                                                                                                                    |
| `docker stop*`                  | destructive            | interrupts container; reversible via start                                                                                                                       |
| `du*`                           | read-only              |                                                                                                                                                                  |
| `env`                           | read-only              |                                                                                                                                                                  |
| `fd *`                          | read-only              |                                                                                                                                                                  |
| `file *`                        | read-only              |                                                                                                                                                                  |
| `find*`                         | read-only              |                                                                                                                                                                  |
| `free*`                         | read-only              |                                                                                                                                                                  |
| `gh issue close*`               | mutation               | reversible via `gh issue reopen`                                                                                                                                 |
| `gh issue list*`                | read-only              |                                                                                                                                                                  |
| `gh pr list*`                   | read-only              |                                                                                                                                                                  |
| `gh pr merge*`                  | destructive            | merges remote PR; hard to reverse; not git-safe                                                                                                                  |
| `gh pr view*`                   | read-only              |                                                                                                                                                                  |
| `git add*`                      | destructive (git-safe) | staging — user example; reversible via reset                                                                                                                     |
| `git branch*`                   | read-only              | listing; destructive forms below                                                                                                                                 |
| `git branch --delete*`          | destructive            | deletes branch; recoverable via reflog until GC                                                                                                                  |
| `git branch --move*`            | destructive            | renames branch ref; affects remote tracking                                                                                                                      |
| `git branch --set-upstream-to*` | destructive            | changing upstream — user example                                                                                                                                 |
| `git branch -D*`                | destructive            | force-deletes unmerged branch                                                                                                                                    |
| `git branch -d*`                | destructive            | deletes merged branch                                                                                                                                            |
| `git branch -m*`                | destructive            | renames branch                                                                                                                                                   |
| `git checkout*`                 | mutation               | branch switch/create; note: plain `git checkout <path>` restores files (destructive) — only `--`/`.`/`-f` gated                                                  |
| `git checkout -- *`             | destructive            | discards uncommitted changes; not recoverable                                                                                                                    |
| `git checkout -b*`              | mutation               | create branch (redundant with `git checkout*`)                                                                                                                   |
| `git checkout -f*`              | destructive            | force discard                                                                                                                                                    |
| `git checkout .*`               | destructive            | discards all changes in cwd                                                                                                                                      |
| `git cherry-pick*`              | destructive            | applies commits, creates history                                                                                                                                 |
| `git clean*`                    | destructive            | deletes untracked files — NOT git-safe                                                                                                                           |
| `git clone*`                    | mutation               | creates new dir; undo via rm                                                                                                                                     |
| `git commit*`                   | destructive            | user example                                                                                                                                                     |
| `git diff*`                     | read-only              |                                                                                                                                                                  |
| `git fetch*`                    | mutation               | updates remote-tracking refs in .git                                                                                                                             |
| `git log*`                      | read-only              |                                                                                                                                                                  |
| `git merge*`                    | destructive            | user example                                                                                                                                                     |
| `git pull*`                     | destructive            | can auto-merge/rebase                                                                                                                                            |
| `git push*`                     | destructive            | publishes to remote                                                                                                                                              |
| `git rebase*`                   | destructive            | rewrites history                                                                                                                                                 |
| `git reset*`                    | destructive            | moves refs; can discard work                                                                                                                                     |
| `git restore*`                  | destructive            | discards changes                                                                                                                                                 |
| `git revert*`                   | destructive            | creates reverse commits                                                                                                                                          |
| `git rm*`                       | destructive (git-safe) | tracked files only; restore via checkout — git-safe, but still gated on build                                                                                    |
| `git show*`                     | read-only              |                                                                                                                                                                  |
| `git stash*`                    | read-only              | list/show; BEWARE bare `git stash` = push (destructive); forms below                                                                                             |
| `git stash apply*`              | destructive (git-safe) | writes working tree; reversible via checkout                                                                                                                     |
| `git stash branch*`             | destructive (git-safe) | creates branch + drops stash                                                                                                                                     |
| `git stash clear*`              | destructive            | recoverable via fsck, hard                                                                                                                                       |
| `git stash drop*`               | destructive            | recoverable via fsck, hard                                                                                                                                       |
| `git stash pop*`                | destructive (git-safe) | applies + drops; conflict keeps the stash                                                                                                                        |
| `git stash push*`               | destructive (git-safe) | pushing to stash — user example; reversible via pop                                                                                                              |
| `git stash save*`               | destructive (git-safe) |                                                                                                                                                                  |
| `git status*`                   | read-only              |                                                                                                                                                                  |
| `git switch*`                   | mutation               | branch switch; refuses to lose changes                                                                                                                           |
| `git tag*`                      | mutation               | create tag; destructive forms below                                                                                                                              |
| `git tag --delete*`             | destructive            | tags have no reflog — hard to recover                                                                                                                            |
| `git tag -d*`                   | destructive            |                                                                                                                                                                  |
| `git worktree*`                 | read-only              | list; forms below                                                                                                                                                |
| `git worktree add*`             | mutation               | creates worktree; undo via remove                                                                                                                                |
| `git worktree remove*`          | destructive            | removes checkout dir; branch/commits stay in repo                                                                                                                |
| `go test*`                      | mutation               | writes test cache                                                                                                                                                |
| `gradlew*`                      | mutation               | gradle build wrapper; output in `build/` (regenerable)                                                                                                           |
| `grep*`                         | read-only              |                                                                                                                                                                  |
| `jest*`                         | mutation               | test runner; writes cache/report                                                                                                                                 |
| `journalctl*`                   | read-only              |                                                                                                                                                                  |
| `jq*`                           | read-only              |                                                                                                                                                                  |
| `kill *`                        | destructive            | terminates processes; unsaved state lost                                                                                                                         |
| `killall *`                     | destructive            |                                                                                                                                                                  |
| `kubectl apply*`                | destructive            | declarative; reversible via git/delete if GitOps, else manual                                                                                                    |
| `kubectl delete*`               | destructive            | deletes cluster resources; hard to reverse                                                                                                                       |
| `kubectl get*`                  | read-only              |                                                                                                                                                                  |
| `lint*`                         | mutation               | also matches `eslint`; `--fix` mutates (git-safe)                                                                                       |
| `ls*`                           | read-only              |                                                                                                                                                                  |
| `lsof*`                         | read-only              |                                                                                                                                                                  |
| `make*`                         | mutation               | runs Makefile targets — impact depends on target; typical `make` builds (regenerable output)                                                                     |
| `make install*`                 | destructive            | common target writes to system paths (non-self-contained); NOT git-safe                                                                                          |
| `mkdir *`                       | mutation               | undo via rmdir                                                                                                                                                   |
| `mount *`                       | destructive            | system mount changes; umount reverses                                                                                                                            |
| `mv *`                          | destructive (git-safe) | moving things — user example; clobbers destination                                                                                                               |
| `mvn*`                          | mutation               | maven build; output in `target/` (regenerable)                                                                                                                   |
| `next*`                         | mutation               | `next build` writes `.next/` (regenerable); `next dev` runs a server                                                      |
| `npm install*`                  | mutation               | nde_modules is self-contained; lockfile diff reversible via git                                                                                                 |
| `npm run*`                      | mutation               | runs package scripts — impact depends on the script; typical build scripts produce regenerable output                                                            |
| `pacman *`                      | destructive            | system packages, non-self-contained                                                                                                                              |
| `paru *`                        | destructive            | AUR helper; builds + installs system packages                                                                                                                    |
| `ping*`                         | read-only              |                                                                                                                                                                  |
| `pip install*`                  | destructive            | global site-packages = non-self-contained; venv = mutation                                                                                                       |
| `pkill *`                       | destructive            |                                                                                                                                                                  |
| `podman compose*`               | destructive            | lifecycle mgmt; `down`/`rm -v` removes containers, networks, volumes; not hooked — passthrough                                                                   |
| `podman images*`                | read-only              | n podman hook at all                                                                                                                                            |
| `podman logs*`                  | read-only              |                                                                                                                                                                  |
| `podman ps*`                    | read-only              |                                                                                                                                                                  |
| `podman rm*`                    | destructive            |                                                                                                                                                                  |
| `podman run*`                   | destructive            | runs arbitrary containers/processes                                                                                                                              |
| `podman stop*`                  | destructive            |                                                                                                                                                                  |
| `prettier*`                     | mutation               | formatting; `--write` rewrites source in place but is reversible via checkout — the borderline case, flagged                                                     |
| `ps*`                           | read-only              |                                                                                                                                                                  |
| `pwd`                           | read-only              |                                                                                                                                                                  |
| `pytest*`                       | mutation               | test runner                                                                                                                                                      |
| `read*`                         | read-only              | cat, head, tail all rewrite here                                                                                                                                 |
| `rg*`                           | read-only              |                                                                                                                                                                  |
| `rm *`                          | destructive (git-safe) | deleting files — user example; git-safe if tracked                                                                                                               |
| `rm -rf*`                       | destructive (git-safe) | order AFTER `rm *`; irreversible outside git                                                                                                                     |
| `rmdir *`                       | destructive            | removes empty dirs                                                                                                                                               |
| `rsync*`                        | destructive            | can overwrite/delete (`--delete`) destination                                                                                                                    |
| `ruff*`                         | mutation               | `ruff check*` and `ruff format*`; bare `ruff` and `ruff --fix*` pass through raw                                          |
| `scp *`                         | destructive            | overwrites remote files                                                                                                                                          |
| `ss*`                           | read-only              |                                                                                                                                                                  |
| `ssh*`                          | destructive            | runs arbitrary commands remotely                                                                                                                                 |
| `stat*`                         | read-only              |                                                                                                                                                                  |
| `sudo *`                        | destructive            | root escalation — arbitrary impact                                                                                                                               |
| `systemctl disable*`            | mutation               | persistent boot config; reversible via enable                                                                                                                    |
| `systemctl enable*`             | mutation               | persistent boot config; reversible via disable                                                                                                                   |
| `systemctl reload*`             | mutation               | graceful config reload                                                                                                                                           |
| `systemctl restart*`            | destructive            | interrupts service (brief downtime)                                                                                                                              |
| `systemctl start*`              | mutation               | reversible via stop                                                                                                                                              |
| `systemctl status*`             | read-only              | only `status` hooks; other subcommands raw                                                                                                                       |
| `systemctl stop*`               | destructive            | interrupts service; potential data loss; reversible via start                                                                                                    |
| `touch *`                       | mutation               | creates/updates timestamps                                                                                                                                       |
| `tree*`                         | read-only              |                                                                                                                                                                  |
| `tsc*`                          | mutation               | typecheck/compile; `--noEmit` read-only, emit writes regenerable output                                                                                          |
| `umount *`                      | destructive            | can interrupt active I/O                                                                                                                                         |
| `uname*`                        | read-only              |                                                                                                                                                                  |
| `uptime`                        | read-only              |                                                                                                                                                                  |
| `uv run*`                       | mutation               | runs the inner command; raw prefix still matches                                                                        |
| `vitest*`                       | mutation               | test runner                                                                                                                  |
| `wc*`                           | read-only              |                                                                                                                                                                  |
| `wget*`                         | mutation               | downloads; appends `.1` on collision, rarely overwrites                                                                                                          |
| `which *`                       | read-only              |                                                                                                                                                                  |
| `yay *`                         | destructive            | AUR helper; builds + installs system packages                                                                                                                    |
