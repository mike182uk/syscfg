---
description: Visualize code, architecture, or concepts as Mermaid diagrams
agent: build
subtask: true
---

Visualize based on the user's input: "$ARGUMENTS".

## Determine what to visualize

Classify the input to decide what to diagram:

- **No input** - Analyze the current project and ask the user what aspect they'd
  like to visualize (architecture, data model, flow, etc.).
- **File or directory path** - Analyze the code and choose the most appropriate
  diagram type.
- **GitHub pull request** (URL or `#N`) - Visualize the changes introduced by the
  PR.
- **Free text** - Treat as a description of what to visualize.

## Load the mermaid skill

Use the `skill` tool to load the `mermaid-diagrams` skill.

## Generate the diagram

When multiple diagram types could work, prefer the one that communicates the most
useful information about the subject.

Keep diagrams focused - if the subject is complex, split into multiple diagrams
rather than cramming everything into one.

Output the diagram in a fenced mermaid code block.
