---
description: Watch an open PR and drive it toward mergeable
agent: build
subtask: false
---

Babysit a pull request toward a mergeable state.

## Determine the pull request

The user's input:

<input>
$ARGUMENTS
</input>

Classify it to identify the target PR:

- **GitHub pull request** (URL, `#N`, or bare number): Use the specified PR.
  Pass the number to `gh` without the leading `#`.
- **No input**: Resolve the PR for the current branch with `gh pr view`. If
  none exists, search the conversation for PR references (URLs, `#N` patterns,
  branch names associated with PRs). If still ambiguous or absent, ask the user
  to specify a PR.
- **Free text**: Treat as additional guidance (e.g. "skip the flaky e2e job",
  "only fix lint", "check in every 3 iterations"). Still resolve the PR from
  branch or conversation context.

## Load the skill

Use the `skill` tool to load the `pull-request-babysit` skill.

## Babysit the pull request

Follow the loaded skill's instructions.

Run the loop in this thread. Do not delegate it to a subagent - it is
long-running and interactive, and needs to stop and ask the user when a
decision needs to be made.
