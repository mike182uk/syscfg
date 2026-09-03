---
description: Review comments on PRs
agent: build
subtask: true
---

Review the comments on a pull request.

## Determine the pull request

The user's input:

<input>
$ARGUMENTS
</input>

Classify it to identify the target PR:

- **GitHub pull request** (URL, `#N`, or bare number): Use the specified PR.
  Pass the number to `gh` without the leading `#`.
- **No input**: Resolve the PR for the current branch with `gh pr view`. If
  none exists, report that and stop - this runs as a subtask with no access to
  the conversation.
- **Free text**: Treat as additional guidance for the analysis (e.g.
  "focus on the auth comments", "include resolved"). Still resolve the PR from
  the current branch.

## Load the skill

Use the `skill` tool to load the `pull-request-comments-review` skill.

## Review the comments

Follow the loaded skill's instructions.

Do not change the code - only provide the analysis.
