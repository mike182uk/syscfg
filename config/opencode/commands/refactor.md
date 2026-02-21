---
description: Refactor code
agent: build
subtask: true
---

Refactor code based on the user's input: "$ARGUMENTS".

## Determine refactor target

Classify the input to decide what to refactor:

- **No input**: Ask the user what they'd like to refactor.
- **File or directory path**: Refactor the specified code.
- **Free text**: Treat as guidance for what and how to refactor.

## Load the skill

Use the `skill` tool to load the `code-refactor` skill.

## Perform the refactor

Follow the loaded skill's instructions to carry out the refactor.
