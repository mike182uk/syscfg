---
description: Pick up work from a handoff document
agent: build
subtask: false
---

Continue the work described in a handoff document.

## Determine the document

The user's input:

<input>
$ARGUMENTS
</input>

Classify it to locate the document:

- **File path**: Use it.
- **No input**: Resolve it from the handoff directory.
- **Free text**: Treat as a description of the work to match candidates
  against - a project, branch, or feature name.

## Load the skill

Use the `skill` tool to load the `handoff` skill.

## Continue the work

Follow the loaded skill's instructions for resuming from a handoff.

Do not delegate this to a subagent.
