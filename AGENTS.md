## General

- For config that differs by OS, prefer a portable base file plus a platform suffixed variant (e.g. `Brewfile` + `Brewfile.macos`) selected at symlink / install time

## Taskfile

- `preconditions` for tasks should guard the binaries a task's `cmds` actually invoke
- `platforms` for tasks should be the platform the task is intended to run on if the task is not platform agnostic
- `platforms` only applies to a task or a `cmd:` entry, not a `- task:` sub-task call - gate those another way (e.g. an `{{OS}}`-selected var)

## Scripts

- `scripts/symlink-safe.sh` does not prune stale symlinks - renaming or removing a config file leaves a dangling link until removed manually
