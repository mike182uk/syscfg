# Communication

- Be concise and direct, avoid filler
  - Cut whole points, not words. Write full sentences, not fragments or arrow chains
- When listing items I may want to respond to individually, such as findings, questions, suggestions, or options, use a numbered list
  - Keep numbering continuous across sections within a response so each item has a unique number
  - Use bullets for purely informational lists
- Do not use emojis unless asked
- Prefer the plainest word. No jargon, no sophisticated synonym use for its own sake
- Prefer the literal thing over a metaphor - "removing X breaks Y", not "X is load-bearing"
- Do not vouch for your own points ("genuinely", "worth noting", "importantly"). State the point

# Time

- Time is not a constraint
- Never scope down, defer, or rank an option lower because it seems time-consuming
- Never estimate how long work will take or frame options by effort estimates (e.g. "quick fix", "~15 minutes of work")
  - When size matters, describe scope (e.g. steps, risk) instead
  - Measured ETAs for external processes (e.g. a running transfer or build) are fine

# Acting on my behalf

- Never take external actions (e.g. posting a comment, sending an email, approving a PR) on my behalf unless I explicitly ask for that specific action

# Documentation & research

Prefer these tools over a plain web search, and fall back to web search if they are unavailable or insufficient. Discover available tools before concluding they are unavailable:

- `context7` - library and framework documentation
- `deepwiki` - how a specific GitHub repo works
- grep.app (the `grep` MCP) - real-world code examples from GitHub
- `exa` - current events and non-code research

# Writing

- In prose, use hyphens (`-`) instead of em-dashes (`—`), en-dashes (`–`), or double hyphens (`--`), including in ranges (e.g. `3-5`)
- Do not use semicolons in prose. Use separate sentences instead

# Environment

- Tools (e.g. `node`, `bun`, `go`, `rust`) are managed by `mise` (not `nvm`, `brew`)
- Packages are managed by `Homebrew`. If not available use the system package manager
- Docker on macOS is `OrbStack`, not `Docker Desktop`

# Tools

- Use `ax` for fetching web pages and HTML extraction instead of the `webfetch` tool, `curl`, or throwaway Python / Node parsing scripts
  - `curl` is fine for APIs, raw files, downloads and status checks
  - Load the `ax` skill before use. If its guidance is insufficient, run `ax agent-context` for the full manual
  - Use another approach only when `ax` cannot handle the task, not merely because an extraction attempt failed
- Use `wt` instead of `git worktree` commands to create or remove worktrees. This also applies when a skill or instruction names a `git worktree` command - run the `wt` equivalent. Only use `git worktree` if `wt` is unavailable or cannot get the desired result
- For repos already checked out under `$DEV_DIR/repos`, use the local checkout (fetch first if you need the latest)
- To read an external repo or package beyond one or two files, or to search its code, use `opensrc`
  - Do not clone it, or read it file by file with `gh api .../contents` or raw.githubusercontent.com URLs
  - Use `git clone` only to make changes or check out a PR

# Browser & desktop automation

- Pick the tool by what the task needs:
  - `agent-browser` - for programmatic browsing and scraping in a clean browser with no logins
  - `browse` - for tasks that need my real browser and logins
    - It can only control tabs it opened. To work in a tab I already have open, ask me to lend it with the browse toolbar button
  - `chrome-devtools` MCP - only for performance traces, Lighthouse audits and memory debugging. It also needs remote debugging turned on in Chrome
  - `cua-driver` - for desktop apps, not web pages
- `browse`, `chrome-devtools` and `cua-driver` are disabled by default. If the one you need is not available, ask me to enable it instead of switching to another tool

# Code

- Before writing, modifying, or reviewing code, load the `karpathy-guidelines` skill

## Paths

- Repositories are cloned to `$DEV_DIR/repos/{personal,oss,...}`
- Worktrees are checked out in `$DEV_DIR/worktrees/{personal,oss,...}`

## General

- Always use pinned versions of dependencies unless the project deviates from this rule
- Do not add comments by default, including docstrings and JSDoc. Add one only for a fact the reader cannot get from the code, types or names:
  - Why the code is the way it is (e.g. a workaround, an external constraint, a surprising choice)
  - On types, fields and exported functions, something a caller would otherwise have to read the implementation to know (e.g. units, format, when an optional value is set)
  - What a script does and how to run it, as a short header
- Never add a comment that restates the name, the type or the code
- Where a project's convention or tooling requires doc comments, follow it
- Before finishing, check your diff for added comments and remove any that do not qualify

## TypeScript

- Never use the `any` type without explicit approval
- Prefer `satisfies`, a type guard, or fixing the source type over an `as` cast. `as const` is not a cast and is fine. If a cast is unavoidable, say why
- Prefer `interface` over `type` for object shapes

## Go

- Before writing or modifying Go code, load the `use-modern-go` skill
  - Follow its version-compatible idioms in changed code. Do not modernize unrelated code

## Shell

- After editing a sh or bash script, format with `shfmt` and lint with `shellcheck`
- After editing a fish file, format with `fish_indent -w`

# Scratch

- One-off work that is not a project (e.g. an investigation, a data gathering exercise, a set of notes) goes in `$SCRATCH_DIR/<YYYY-MM-DD>-<slug>/`, dated when the work starts
- Security audits generated by the `security-audit` skill should use a scratch directory instead of the skill's default `~/security-audit-skill/` directory
