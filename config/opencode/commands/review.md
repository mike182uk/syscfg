---
description: Review code, PRs, or issues
agent: build
subtask: true
---

Review code, a pull request, or an issue.

## Determine review type

The user's input:

<input>
$ARGUMENTS
</input>

Classify it to decide which type of review to perform:

- **No input**: Code review of the current uncommitted changes.
- **File or directory path**: Code review.
- **Commit SHA, branch, or commit range** (e.g. `abc1234`, `main...feature`):
  Code review of those changes.
- **GitHub pull request** (URL, or a number that resolves to a PR): Pull
  request review.
- **GitHub issue** (URL, or a number that resolves to an issue): Issue review.
- **Issue tracker reference** (e.g. `ABC-123`, or a URL to Linear, Jira,
  etc.): Issue review.
- **Free text**: Treat as guidance for the review, and resolve the target from
  the rest of the input or the conversation.

A bare number is ambiguous - GitHub numbers issues and PRs in one sequence. Try
`gh pr view <n>` first and fall back to `gh issue view <n>`. Pass the number
without a leading `#`.

## Load the relevant skill

Based on the determined review type, use the `skill` tool to load the
appropriate skill:

- **Code reviews**: load the `code-review` skill.
- **Pull request reviews**: load the `pull-request-review` skill.
- **Issue reviews**: load the `issue-review` skill.

## Perform the review

Follow the loaded skill's instructions.

If it is unclear what should be reviewed, report what is ambiguous and stop. Do
not attempt a review without a clear target.

Do not make any changes - only provide the review.
