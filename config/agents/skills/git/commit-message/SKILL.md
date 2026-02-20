---
name: git-commit-message
description: Generate a consistent commit message that follows a project's existing conventions. Use when the user asks to commit changes or write a commit message.
---

## Gathering Context

Run the following to understand what has changed and how this project's commit
messages are structured:

- `git log -10` (full format, not `--oneline`, so you can see body conventions)
- `git diff HEAD` (staged and unstaged changes)
- `git status` to identify untracked files, then read any untracked files so you
  understand what was added

If you are in a conversation, also review the session history to understand the
intent behind the changes.

## Conventions

Check for documented commit conventions (e.g. in `CONTRIBUTING.md` or similar).
Documented conventions take precedence over observed patterns.

If there are no documented conventions, infer the commit style from the
log: tense, casing, punctuation, length, and whether messages focus on the why
or the what, to produce a message that fits naturally alongside existing commits.

If there is no commit history and no documented conventions, use a concise
imperative-mood subject line describing what the change does.

Unless a convention says otherwise, keep the subject line to 72 characters or
fewer.

If the changes are complex or span multiple concerns, use a subject + body
rather than cramming everything into one line. The body should explain why the
change was made, not what was changed - the diff already shows the what.

If the project conventions include issue references in commits, and the relevant
issue is clear from context, include it between the subject and body, using the 
appropriate keyword:

- `refs` - references the issue
- `closes` - closes the issue

Do not guess or fabricate issue references.

## Rules

- Never use emojis unless a documented convention explicitly specifies when to 
  use them. The presence of emojis in past commits is not sufficient 
  justification.
- Never include git trailers such as `Co-authored-by`, `Signed-off-by`, or 
  similar.
- Use backticks for technical references such as variable names, function names,
  CLI commands, etc.
- Do not include file names directly.
- Do not end with a period.

## Examples

These demonstrate the principles above, not a fixed format. Adapt style to
match the project's existing conventions:

### Simple change (subject only)

```
Add rate limiting to the `/auth` endpoint
```

### Multi-concern change (subject + body)

```
Rework session handling to support concurrent connections

The previous implementation held a single lock for all sessions,
causing timeouts under load. Each session now gets its own lock,
and idle sessions are reaped after 30 seconds.
```

### With issue reference

```
Fix timeout during bulk CSV import

refs https://linear.app/team/ENG-1234

The import job was holding a single database connection for the
entire batch. Splitting into chunked transactions keeps each one
under the connection timeout.
```
