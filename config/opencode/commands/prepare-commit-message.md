---
description: Prepare a commit message
agent: build
subtask: false
---

Prepare a commit message for the current uncommitted changes.

If provided, treat the following as additional guidance for the commit message:

<input>
$ARGUMENTS
</input>

## Load the skill

Use the `skill` tool to load the `git-commit-message` skill.

## Write the message

Follow the loaded skill's instructions.

Output only the commit message. Do not stage, commit, or otherwise modify
repository state.
