---
description: Write a handoff document so a fresh session can continue the work
agent: build
subtask: false
---

Write a handoff document capturing the current conversation so a fresh agent
can continue the work without re-deriving it.

If provided, treat the following as additional guidance for the document:

<input>
$ARGUMENTS
</input>

## Load the skill

Use the `skill` tool to load the `handoff` skill.

## Write the document

Follow the loaded skill's instructions for writing a handoff.

Do not delegate this to a subagent.
