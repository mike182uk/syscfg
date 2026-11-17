---
description: Deep research on a question, with a written report
agent: build
subagent: true
---

Research a question in depth.

## Determine the question

The user's input:

<input>
$ARGUMENTS
</input>

- **Question or topic**: Research it.
- **No input**: This runs as a background subagent with no access to the
  conversation, so there is nothing to research. Report that a question is
  needed and stop.

## Load the skill

Use the `skill` tool to load the `research` skill.

## Research

Follow the loaded skill's instructions at deep depth.

Where the skill would put a request to the user, such as approving a paid
provider call, report it in the output instead. This runs in the background,
so no one can answer mid-run.
