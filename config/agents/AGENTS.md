# Environment

- Operating system: macOS
- Shell: `fish` (not `zsh`), likely in a `tmux` session
- Tools: `node`, `bun`, `go`, etc. are managed by `mise` (not `nvm`, `brew`)
- Docker management: `Orbstack` (not `Docker Desktop`)

# Communication

- Be concise and direct, avoid filler
- Don't use emojis unless asked

# Documentation & Research

- When looking up documentation, use the context7 MCP first before searching the web
- If you are unsure how to do something, use the grep MCP to search code examples from github
- When citing sources, include URLs

# Code

## General

- Follow existing code style and patterns in the project
- Keep changes minimal and focused
- Always use pinned versions of dependencies unless the project deviates from this rule
- Use `ast-grep` (`sg`) for structural code searches and refactoring when pattern-based search isn't sufficient

## TypeScript

- Never use the `any` type without explicit approval
- Never use `as` without exploring alternative options first
- Prefer `interface` over `type` for object shapes

## Shell

- Use `shfmt` to format shell scripts
- Use `shellcheck` to lint shell scripts
