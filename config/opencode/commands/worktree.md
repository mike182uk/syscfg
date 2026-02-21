---
description: Create a new worktree for the current project
agent: build
subtask: true
---

Create a worktree based on the user's input: "$ARGUMENTS".

## Validate input

If no input was provided, ask the user what they need. Possible inputs:

- **Branch name**: Create a new feature branch worktree.
- **GitHub pull request** (URL or `#N`): Create a worktree for PR review.
- **Issue tracker reference** (URL or ID, e.g. `ENG-1234` or a Linear/Jira
  URL): Fetch the issue title, derive a branch name from it (e.g.
  `ENG-1234-fix-login-timeout`), and create a new feature branch worktree.
- **Existing remote branch**: Create a worktree tracking that branch.
- **Tag or commit ref**: Create a detached HEAD worktree.
- **Free text description**: Treat as a description for a new feature branch.
  Derive a branch name from the text.

Do not proceed without input.

## Load the skill

Use the `skill` tool to load the `parallel-work` skill.

## Create the worktree

Follow the loaded skill's instructions to create the worktree.
