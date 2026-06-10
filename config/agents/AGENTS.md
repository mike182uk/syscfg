# Communication

- Be concise and direct, avoid filler
- Do not use emojis unless asked

# Acting on my behalf

- Never take public actions (e.g., posting a comment, sending an email, approving a PR) on my behalf unless I explicitly ask for that specific action

# Self improvement

- When I correct your behavior in a way that would recur across sessions, propose a one-line rule for the relevant `AGENTS.md` (global or project); show the diff, don't edit without approval

# Documentation & research

- When looking up documentation, use the context7 MCP first before searching the web
- If you are unsure how to do something, use the grep MCP to search code examples from github
- For general web search, current events, or researching topics outside of code, use the exa MCP

# Writing

- Use hyphens instead of em-dashes (`—`) or double hyphens (`--`)

# Environment

- Operating system: macOS
- Shell: `fish` (not `zsh`), likely in a terminal multiplexer (`tmux`, `zellij`, `herdr`)
- Tools: `node`, `bun`, `go`, etc. are managed by `mise` (not `nvm`, `brew`)
- Docker management: `Orbstack` (not `Docker Desktop`)

# Code

## Paths

- Repositories are cloned to `~/Developer/repos/{personal,oss,...}`
- Worktrees are checked out in `~/Developer/worktrees/{personal,oss,...}`

## General

- Follow existing code style and patterns in the project
- Keep changes minimal and focused
- Always use pinned versions of dependencies unless the project deviates from this rule
- Use `ast-grep` (`sg`) first for structural tasks (renames, refactors, finding usages); Grep is for plain text

## TypeScript

- Never use the `any` type without explicit approval
- Never use `as` without exploring alternative options first
- Prefer `interface` over `type` for object shapes

## Shell

- Use `shfmt` to format shell scripts
- Use `shellcheck` to lint shell scripts
