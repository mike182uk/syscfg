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
  none exists, search the conversation for PR references (URLs, `#N` patterns,
  branch names associated with PRs). If still ambiguous or absent, report what
  is ambiguous and stop.
- **Free text**: Treat as additional guidance for the analysis (e.g.
  "focus on the auth comments", "include resolved"). Still resolve the PR from
  branch or conversation context.

Resolve the PR's owner, repo, and number up front, and pass all three
explicitly to every call below. The PR may live in a different repository than
the current directory, in which case `gh`'s `{owner}`/`{repo}` placeholders
would silently query the wrong repo.

## Fetch comments

Gather PR comment data using `gh`. Run these in parallel:

- `gh pr view <number> --repo <owner>/<repo>` - title, description, author,
  base branch
- `gh pr diff <number> --repo <owner>/<repo>` - the full diff
- `gh api repos/<owner>/<repo>/pulls/<number>/reviews --paginate` - review
  summaries
- `gh api repos/<owner>/<repo>/issues/<number>/comments --paginate` -
  PR-level conversation comments, which are a separate endpoint from the
  inline review threads and often carry substantive objections
- The inline review threads, using the GraphQL query below

Fetch inline comments as review threads rather than from the REST
`/pulls/<number>/comments` endpoint - REST does not expose thread resolution
state:

```sh
gh api graphql --paginate -f query='
  query($owner: String!, $repo: String!, $number: Int!, $endCursor: String) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $number) {
        reviewThreads(first: 100, after: $endCursor) {
          pageInfo { hasNextPage endCursor }
          nodes {
            isResolved
            isOutdated
            path
            line
            comments(first: 50) {
              totalCount
              nodes { author { login } body url }
            }
          }
        }
      }
    }
  }' -F owner=<owner> -F repo=<repo> -F number=<number>
```

`--paginate` needs the `$endCursor` variable and `pageInfo` selection above -
without them only the first page comes back. It pages threads, not the comments
inside one: where a thread's `comments.totalCount` exceeds the nodes returned,
fetch the rest of that thread before judging it.

If `gh` commands fail (auth error, PR not found, rate limit), report the
error and stop.

### Filter comments

- **Exclude resolved threads** (`isResolved: true`), unless the user
  explicitly asked to include them (e.g. "include resolved", "all comments",
  "resolved too").
- **Exclude purely informational comments** that do not request a change or
  raise a concern - acknowledgements ("LGTM", "nice"), status updates etc.
  Focus on actionable feedback.
- **Weight human comments over bot comments.** Treat feedback from human
  reviewers as the priority. Automated reviewers (e.g. CodeRabbit, Copilot,
  Sonar, Dependabot, linters posting as comments) are often noisy or wrong -
  treat them as low-priority hints, and group them separately in the output.
- **Keep** comments that request changes, ask questions, flag issues, or
  suggest alternatives.

## Gather context

For each actionable comment, read enough surrounding code to understand what
the reviewer is referring to:

- Read the file and region the comment targets in the current working tree.
  Verify the local checkout matches the PR branch first (`gh pr view <number>
  --repo <owner>/<repo> --json headRefName`). If it does not, read from the
  diff instead of local files.
- If the comment references other files, types, or call sites, read those
  too.
- Check whether subsequent commits in the PR already address the comment by
  comparing the commented region against the latest state of the diff.
  `isOutdated` on the thread is a signal the code has moved since, not proof
  the concern was handled.

## Analyze and output

Start with a summary line: total comment count broken down by status (e.g.
"12 comments: 7 open, 3 addressed, 2 need discussion").

Then for each actionable comment, grouped by file, with human comments first
and any bot comments worth mentioning in a separate section at the end:

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

Do not make any code changes. Do not perform your own code review. Only
provide the analysis.
