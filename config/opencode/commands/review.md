---
description: Review code, PRs, or issues
agent: build
subtask: true
---

Perform a review based on the user's input: "$ARGUMENTS".

## Determine review type

Classify the input to decide which type of review to perform:

- **No input**: Code review of the current uncommitted changes.
- **File or directory path**: If the file or directory has uncommitted changes, 
  code review those changes. Otherwise, do a general review of the file.
- **GitHub pull request** (URL or `#N`): Pull request review.
- **GitHub issue** (URL or `#N`): Issue review.
- **Issue tracker reference** (e.g. `ABC-123` or a URL to Linear, Jira, etc.): Issue review.

## Load the relevant skill

Based on the determined review type, use the `skill` tool to load the appropriate skill:

- For **code reviews**, load the `code-review` skill.
- For **pull request reviews**, load the `pull-request-review` skill.
- For **issue reviews**, load the `issue-review` skill.

## Perform the review

Follow the loaded skill's instructions to carry out the review.

If the input is free text, treat it as guidance for the review. If it is unclear 
what should be reviewed, ask the user to be more specific. Do not attempt a 
review without a clear target.

Do not action any changes - only provide the review.
