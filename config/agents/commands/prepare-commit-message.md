---
description: Prepare a commit message
agent: build
model: anthropic/claude-sonnet-4-6
---

Run the following to understand what has changed and how this project writes
commit messages:

- `git log -10` (full format, not `--oneline`, so you can see body conventions)
- `git diff HEAD` (staged and unstaged changes)
- `git status` to identify untracked files, then read any untracked files so you
  understand what was added

If you are in a conversation, also review the session history to understand the
intent behind the changes.

Check for documented commit conventions (e.g. in `CONTRIBUTING.md` or similar)
before inferring from history. Documented conventions take precedence over
observed patterns.

If there are no documented conventions, infer the commit style from the
log: tense, casing, punctuation, length, and whether messages focus on the why
or the what, and write a message that fits naturally alongside existing commits.

If there is no commit history and no documented conventions, write a concise
imperative-mood subject line describing what the change does.

Unless a convention says otherwise, keep the subject line to 72 characters or
fewer. If the changes are complex or span multiple concerns, use a subject + body
rather than cramming everything into one line.

Never use emojis unless a documented convention explicitly specifies when to use
them. The presence of emojis in past commits is not sufficient justification.

Never include git trailers such as `Co-authored-by`, `Signed-off-by`, or similar
unless the user explicitly requests them.

Use backticks when referencing technical things in the commit message, such as
variable names, function names, CLI commands, etc.

Do not use file names in the commit message.

If provided, treat the following as additional instruction to guide the commit
message: "$ARGUMENTS"

Output only the commit message and a one-sentence rationale explaining the
stylistic choices made. Do not stage files or run any other git commands.
