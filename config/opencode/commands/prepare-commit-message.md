---
description: Prepare a commit message
agent: build
model: anthropic/claude-sonnet-4-6
---

Prepare a commit message for the user's changes.

If provided, treat the following as additional instruction to guide the commit
message: "$ARGUMENTS".

Output only the commit message and a one-sentence rationale explaining the
stylistic choices made. Do not stage files or run any other git commands.
