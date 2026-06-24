---
description: Watch an open PR and drive it toward mergeable
agent: build
---

Babysit a pull request based on the user's input: "$ARGUMENTS".

## Determine the pull request

Classify the input to identify the target PR:

- **GitHub pull request** (URL or `#N`): Use the specified PR.
- **No input**: Find the PR for the current branch with
  `gh pr view --json number,url,headRefName`. If none exists, search the
  conversation for PR references. If still ambiguous or absent, ask the user to
  specify a PR.
- **Free text**: Treat as additional guidance (e.g. "skip the flaky e2e job",
  "only fix lint", "check in every 3 iterations"). Still resolve the PR from
  branch or conversation context.

## Load the skill

Use the `skill` tool to load the `babysit-pr` skill.

## Babysit the pull request

Follow the loaded skill's instructions to run the watch loop against the
resolved PR, applying any free-text guidance from the input.

This is an interactive, long-running loop, not a subtask - keep it in the main
thread so it can stop and ask the user when a decision is needed.
