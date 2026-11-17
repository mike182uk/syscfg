---
description: Deep research on a question, with a written report
agent: build
subagent: false
---

Research a question in depth.

## Determine the question

The user's input:

<input>
$ARGUMENTS
</input>

- **Question or topic**: Research it.
- **No input**: Research the topic under discussion in the conversation. If
  there is none, ask the user what to research.

## Load the skill

Use the `skill` tool to load the `research` skill.

## Research

Follow the loaded skill's instructions at deep depth.
