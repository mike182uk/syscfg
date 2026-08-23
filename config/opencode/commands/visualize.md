---
description: Visualize code, architecture, or concepts as Mermaid diagrams
agent: build
subtask: true
---

Visualize code, architecture, or a concept as a Mermaid diagram.

## Determine what to visualize

The user's input:

<input>
$ARGUMENTS
</input>

Classify it to decide what to diagram:

- **No input**: Identify the candidate subjects worth diagramming
  (architecture, data model, key flows), report them, and stop. Do not pick one
  unprompted.
- **File or directory path**: Analyze the code and choose the most appropriate
  diagram type.
- **GitHub pull request** (URL, `#N`, or bare number): Visualize the changes
  introduced by the PR. Pass the number to `gh` without the leading `#`.
- **Free text**: Treat as a description of what to visualize.

## Load the skill

Use the `skill` tool to load the `mermaid-diagrams` skill.

## Generate the diagram

Follow the loaded skill's instructions.

When multiple diagram types could work, prefer the one that communicates the
most useful information about the subject.

Output the diagram in a fenced mermaid code block. Do not write it to a file
unless the user asked for one.

Then output a Mermaid Live Editor link so it can be viewed rendered. Compute
the encoding by running the command below - never write the base64 out by
hand. Prefix the result with `https://mermaid.live/edit#base64:`.

```sh
jq -Rscj '{code:., mermaid:"{\"theme\":\"default\"}"}' <<'MMD' | base64 | tr -d '\n'
<diagram source>
MMD
```
