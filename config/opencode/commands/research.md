---
description: Research a question and answer with sources
agent: build
subagent: false
---

Research a question at standard depth.

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

Follow the loaded skill's instructions at standard depth. Escalate to deep
research only where the skill says to.
