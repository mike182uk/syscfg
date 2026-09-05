# Communication

- Be concise and direct, avoid filler. Keep it short by leaving things out, not by compressing sentences into fragments, abbreviations, or arrow chains
- After finishing a task, lead with the outcome or findings. Put supporting detail afterward
- When listing items I may want to respond to individually, such as findings, questions, suggestions, or options, use a numbered list. Keep numbering continuous across sections within a response so each item has a unique number. Use bullets for purely informational lists
- Do not use emojis unless asked
- Prefer the plainest word. No coined verbs, no jargon, no sophisticated synonym use for its own sake
- Prefer the literal thing over a metaphor - "removing X breaks Y", not "X is load-bearing"
- No flourish or self-vouching ("genuinely", "worth noting"): show why it matters, don't assert that it does

# Time

- Time is not a constraint
- Never scope down, defer, or rank an option lower because it seems time-consuming
- Never estimate how long work will take or frame options by effort estimates (e.g. "quick fix", "~15 minutes of work")
  - When size matters, describe scope (e.g. steps, risk) instead
  - Measured ETAs for external processes (e.g. a running transfer or build) are fine

# Acting on my behalf

- Never take external actions (e.g. posting a comment, sending an email, approving a PR) on my behalf unless I explicitly ask for that specific action

# Documentation & research

Prefer these tools over a plain web search, and fall back to web search if they are unavailable or insufficient. Discover available integration tools before concluding they are unavailable:

- `context7` - library and framework documentation
- `deepwiki` - how a specific GitHub repo works
- `grep` (grep.app) - real-world code examples from GitHub
- `exa` - current events and non-code research

# Writing

- In prose, use hyphens (`-`) instead of em-dashes (`—`), en-dashes (`–`), or double hyphens (`--`)
- Do not use semicolons in prose. Use separate sentences instead

# Environment

- Tools (e.g. `node`, `bun`, `go`, `rust`) are managed by `mise` (not `nvm`, `brew`)
- Packages are managed by `Homebrew`. If not available use the system package manager
- Docker is managed by `Orbstack` on macOS (not `Docker Desktop`) or standard Docker on Linux

# Tools

- Use `ax` for web fetching and HTML extraction instead of `curl` or throwaway Python / Node parsing scripts
  - Load the `ax` skill before use. If its guidance is insufficient, run `ax agent-context` for the full manual
  - Use another approach only when `ax` cannot handle the task, not merely because an extraction attempt failed
- Use `wt` instead of `git worktree` commands to create, list, or remove worktrees. This also applies when a skill or instruction names a `git worktree` command - run the `wt` equivalent. Only use `git worktree` if `wt` is unavailable or cannot get the desired result
- Prefer `grep` (grep.app) for checking external GitHub code
  - When local repository inspection is needed, use an existing local checkout if available. Otherwise, use `opensrc` instead of `git clone`

# Code

- Before writing, modifying, or reviewing code, load the `karpathy-guidelines` skill

## Paths

- Repositories are cloned to `$DEV_DIR/repos/{personal,oss,...}`
- Worktrees are checked out in `$DEV_DIR/worktrees/{personal,oss,...}`

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
- For type errors, complex generics, or inference problems, load the `typescript-magician` skill

## Go

- Before writing or modifying Go code, load the `use-modern-go` skill
  - Follow its version-compatible idioms in changed code. Do not modernize unrelated code

## Shell

- After editing a shell script, format with `shfmt` and lint with `shellcheck`
