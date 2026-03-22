---
description: Review comments on PRs
agent: build
subtask: true
---

Review comments on a pull request based on the user's input: "$ARGUMENTS".

## Determine the pull request

Classify the input to identify the target PR:

- **GitHub pull request** (URL or `#N`): Use the specified PR.
- **No input**: Search the current conversation for PR references (URLs,
  `#N` patterns, branch names associated with PRs). If multiple references
  are found, ask the user which PR to use. If no references are found, ask
  the user to specify a PR.
- **Free text**: Treat as additional guidance for the analysis (e.g.
  "focus on the auth comments", "include resolved"). Still attempt to
  find the PR from conversation context.

## Fetch comments

Gather PR comment data using `gh`. Run these in parallel:

- `gh pr view <number>` - title, description, author, base branch
- `gh api repos/{owner}/{repo}/pulls/<number>/comments` - inline review
  comments
- `gh api repos/{owner}/{repo}/pulls/<number>/reviews` - review summaries
- `gh pr diff <number>` - the full diff

If `gh` commands fail (auth error, PR not found, rate limit), report the
error and stop.

### Filter comments

- **Exclude comments that have been resolved** - e.g. the thread has a
  reply indicating the feedback was accepted, or the code has been updated
  accordingly. Unless the user explicitly asked to include them (e.g.
  "include resolved", "all comments", "resolved too").
- **Exclude purely informational comments** that do not request a change or
  raise a concern - acknowledgements ("LGTM", "nice"), status updates etc. 
  Focus on actionable feedback.
- **Keep** comments that request changes, ask questions, flag issues, or
  suggest alternatives.

## Gather context

For each actionable comment, read enough surrounding code to understand what
the reviewer is referring to:

- Read the file and region the comment targets in the current working tree.
  Verify the local checkout matches the PR branch first (`gh pr view
  --json headRefName`). If it does not, read from the diff instead of local
  files.
- If the comment references other files, types, or call sites, read those
  too.
- Check whether subsequent commits in the PR already address the comment by
  comparing the commented region against the latest state of the diff.

## Analyze and output

Start with a summary line: total comment count broken down by status (e.g.
"12 comments: 7 open, 3 addressed, 2 need discussion").

Then for each actionable comment, grouped by file:

1. **File and line** - location the comment targets.
2. **Reviewer** - who left the comment.
3. **Comment** - the reviewer's feedback, quoted or summarized.
4. **Status** - `open`, `addressed` (by a subsequent commit), or `unclear`.
5. **Analysis** - your assessment:
   - Is the concern valid?
   - What is the right fix or response?
   - If already addressed, note how.
   - If you disagree with the reviewer, explain why with evidence from the
     code.
6. **Suggested action** - a concrete next step: apply the change, push
   back with rationale, or flag for discussion.

Do not make any code changes. Do not perform your own code review. Only provide the analysis.
