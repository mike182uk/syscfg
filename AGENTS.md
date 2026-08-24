## General

- For config that differs by OS, prefer a portable base file plus a platform suffixed variant (e.g. `Brewfile` + `Brewfile.macos`) selected at symlink / install time

## Taskfile

- `preconditions` for tasks should guard the binaries a task's `cmds` actually invoke
- `platforms` for tasks should be the platform the task is intended to run on if the task is not platform agnostic
- `platforms` only applies to a task or a `cmd:` entry, not a `- task:` sub-task call - gate those another way (e.g. an `{{OS}}`-selected var)

## Scripts

- `scripts/symlink-safe.sh` does not prune stale symlinks - renaming or removing a config file leaves a dangling link until removed manually

## Opencode commands

- `description` in frontmatter is TUI-only and is never sent to the model - the body needs its own task statement
- Always set `subtask` explicitly
- `subtask: true` runs the command in a child session: it cannot ask the user (report what is ambiguous and stop instead) and cannot see the conversation
- `subtask: false` does not stop the agent delegating the work to a subagent via the Task tool - say so in the body if it must stay in-thread
- Inline `"$ARGUMENTS"` renders as `""` when the user passes nothing, which reads as a deliberately empty value. An `<input>` block avoids that, and marks where free text ends
- Keep commands small and focused. If one grows large or sprouts branching logic, suggest moving the procedure into a skill and have the command dispatch to it
  - Personal skills live in `~/Developer/repos/personal/agent-skills`
  - Third-party skills are installed by `Taskfile.yml` into `~/.agents/skills`
- When a command dispatches to a skill, do not restate what the skill already covers - the two copies will drift
- Restrict a command by outcome, not by tool: "do not commit" rather than "do not run git commands", which would also block the `git log` and `git diff` the command needs
- Wrap command files at 80 columns
- When referencing `gh`:
  - Strip a leading `#` before passing a number to `gh`
  - A bare number is ambiguous - GitHub numbers issues and PRs in one sequence
  - `gh api` does not paginate by default; pass `--paginate`
  - Pass `--repo <owner>/<repo>` explicitly - `{owner}`/`{repo}` resolve from the current directory, not from the PR
  - REST `/pulls/<n>/comments` has no resolution state; use GraphQL `reviewThreads`
