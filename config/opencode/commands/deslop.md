---
description: Remove AI slop from code or text
agent: build
subtask: true
---

Remove AI slop based on the user's input: "$ARGUMENTS".

## Determine what to deslop

Classify the input to decide which type of deslop to perform:

- **No input**: Deslop uncommitted changes. If the diff contains code,
  treat as a code deslop. If it contains only prose (markdown, docs),
  treat as a text deslop.
- **File or directory path**: Inspect the files. Code files get a code
  deslop; prose files (markdown, READMEs, docs) get a text deslop. If
  the path contains both, do both.
- **Free text**: Treat as text to deslop directly.

## Load the relevant skill

Based on the determined type, use the `skill` tool to load the
appropriate skill:

- For **code deslop**, load the `code-deslop` skill.
- For **text deslop**, load the `humanizer` skill.

If the target contains both code and prose (e.g. a codebase with markdown
docs and source files), load both skills and apply each to the relevant
files.

## Perform the deslop

Follow the loaded skill's instructions to carry out the deslop.

If the input is free text, treat it as guidance for the deslop. If it is
unclear what should be deslopped, ask the user to be more specific.
