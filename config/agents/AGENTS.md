# Communication

- Be concise and direct, avoid filler
- Do not use emojis unless asked

# Acting on my behalf

- Never take public actions (e.g. posting a comment, sending an email, approving a PR) on my behalf unless I explicitly ask for that specific action

# Documentation & research

If these tools are available, prefer them over a plain web search, and fall back to web search if they come up empty:

- `context7` - library and framework documentation
- `deepwiki` - how a specific GitHub repo works
- `grep` (grep.app) - real-world code examples from GitHub
- `exa` - current events and non-code research

# Writing

- In prose, use hyphens (`-`) instead of em-dashes (`—`), en-dashes (`–`), or double hyphens (`--`)

# Environment

- Tools (e.g. `node`, `bun`, `go`, `rust`) are managed by `mise` (not `nvm`, `brew`)
- Packages are managed by `Homebrew`. If not available use the system package manager
- Docker is managed by `Orbstack` on macOS (not `Docker Desktop`) or standard Docker on Linux

# Tools

- Use `ax` instead of `curl`. Only use `curl` if you cannot get the desired result with `ax`
  - Load the `ax` skill before use
- Use `wt` instead of `git worktree` commands to create, list, or remove worktrees. Only use `git worktree` if you cannot get the desired result with `wt`

# Code

## Paths

- Repositories are cloned to `~/Developer/repos/{personal,oss,...}`
- Worktrees are checked out in `~/Developer/worktrees/{personal,oss,...}`

## General

- Follow existing code style and patterns in the project
- Keep changes minimal and focused
- Always use pinned versions of dependencies unless the project deviates from this rule
- Only write comments when the code itself is not self-explanatory. Comments should be the exception not the norm
- After changing code, run the project's formatter and linter, and the tests covering what you changed. Say which commands you ran, and say so if you skipped any

## TypeScript

- Never use the `any` type without explicit approval
- Prefer `satisfies`, a type guard, or fixing the source type over an `as` cast. `as const` is not a cast and is fine. If a cast is unavoidable, say why
- Prefer `interface` over `type` for object shapes

## Shell

- After editing a shell script, format with `shfmt` and lint with `shellcheck`
