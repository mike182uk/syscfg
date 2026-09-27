## General

- For config that differs by OS, prefer a portable base file plus a platform suffixed variant (e.g. `Brewfile` + `Brewfile.macos`) selected at symlink / install time

## Taskfile

- `preconditions` for tasks should guard the binaries a task's `cmds` actually invoke
- `platforms` for tasks should be the platform the task is intended to run on if the task is not platform agnostic
- `platforms` only applies to a task or a `cmd:` entry, not a `- task:` sub-task call - gate those another way (e.g. an `{{OS}}`-selected var)
- Tasks should be able to be run multiple times without error
- Tasks should not rely on external state or resources that have not been set up yet

## Scripts

- `scripts/symlink-safe.sh` does not prune stale symlinks - renaming or removing a config file leaves a dangling link until removed manually

## Themes

- Tools that support theming should use `tokyonight`, specifically the `moon` variant if available
  - See https://github.com/folke/tokyonight.nvim
  - Prefer the file from `/extras` verbatim, named `tokyonight_moon` 
    - Only hand-write a theme when upstream has none, using values from `lua/tokyonight/colors/moon.lua`
  - Bat and Codex share `config/themes/tokyonight_moon.tmTheme` (from `extras/sublime`). Do not create separate copies
- `tokyonight_mike` is the moon palette with the role assignments of opencode's built-in `tokyonight` theme
  - See https://github.com/anomalyco/opencode/blob/dev/packages/tui/src/theme/assets/tokyonight.json
  - `config/opencode/themes/tokyonight_mike.json` is the reference: `diff` it against `tokyonight_moon.json` to see the full delta in palette terms
  - Palette-level delta, applied to every tool that has the role: 
    - bg: `#1a1b26`
    - element / cursor-line: `#222436`
    - comment: `#828bb8`
    - border: `#737aa2`
    - active/float border: `#828bb8`
    - text selection stays `bg_visual` `#2d3f76`
    - diff add/remove bg: `#20303b`/`#37222c`
    - error: `red`
    - warning: `orange`
    - info: `blue`
  - Markdown roles (opencode, nvim, tmTheme): 
    - heading: `magenta`
    - strong: `orange`
    - emphasis: `yellow`
    - links: `cyan`
    - list markers: `blue` (opencode also has `markdownListEnumeration`, which is `cyan`)
    - block quote: `yellow`
  - The built-in's syntax roles (variable / parameter / property / call `red`, type `yellow`, keyword `magenta`) are kept in the opencode file only - nvim and the `tmTheme` keep upstream tokyonight syntax
  - The built-in's off-palette values (`#89b4fa`, `#9099b2`, `#8f909a`) are replaced with `#65bcff` / `#828bb8`. Do not reintroduce them
  - Every `tokyonight_moon` theme file has a `tokyonight_mike` sibling - `THEMES` in `Taskfile.yml` links both so switching is an edit to the tool's config
  - Where the theme is inline config, both variants stay in the file e.g. herdr `[theme.custom]` holds a full `tokyonight_moon` block (commented) and a full `tokyonight_mike` block (active) with every documented key
  - fish and fzf set their colours with ANSI names (`config.fish`, `config/fzf/fzfrc`) so they follow the terminal palette - do not add the upstream fish or fzf themes
  - eza is not themed
  - When updating from upstream, re-derive `tokyonight_mike` from the new `tokyonight_moon` file plus the delta above rather than editing it directly
- VS Code, Zed & Sublime Text use their own themes. Do not modify them

## Coding agents

- OpenCode, Claude Code and Codex are kept aligned. When changing one, make the same change in the others, or say why it can't be expressed there
- Where each setting lives:
  - Models: `config/opencode/opencode.jsonc`, `config/claude/settings.json`, `config/codex/personal.config.toml`, and the agent entries in `config/zed/settings.json`
  - Bash permission rules: `opencode.jsonc`, Claude Code `settings.json`, `config/codex/rules/default.rules`
  - File read rules (`.env`): `opencode.jsonc`, Claude Code `settings.json`, the Codex permission profile in `personal.config.toml`
  - Access to directories outside the project: `external_directory` in `opencode.jsonc`, `additionalDirectories` in Claude Code `settings.json` plus `config/fish/functions/claude.fish`, and Codex workspace roots in `config/fish/functions/codex.fish`
  - MCP servers: `opencode.jsonc`, the `claude` and `codex` tasks in `Taskfile.yml`, and `personal.config.toml`
- Effort / reasoning level is left at each model's default. Do not set it
- Claude Code and Codex config can't read env vars (`~/` works in both). Paths built from `DEV_DIR` / `SCRATCH_DIR` go in the fish wrappers
- Codex drops `-c` overrides given before a subcommand when another `-c` follows it, so `codex exec -c ...` loses the wrapper's workspace roots
- OpenCode permission rules are last-match-wins: broad rules first, narrow rules last
- Claude Code evaluates deny, then ask, then allow - an allow can't carve an exception out of a deny
- Claude Code `Read` patterns without a `//` or `~/` prefix are relative to the working directory, so user-level rules that must apply everywhere use `//**/...`
- Codex filesystem globs only support `deny`, so a read exception such as `.env.example` can only be an exact path

## Opencode commands

- `description` in frontmatter is TUI-only and is never sent to the model - the body needs its own task statement
- Always set `subtask` explicitly
- `subtask: true` runs the command in a child session: it cannot ask the user (report what is ambiguous and stop instead) and cannot see the conversation
- `subtask: false` does not stop the agent delegating the work to a subagent via the Task tool - say so in the body if it must stay in-thread
- Inline `"$ARGUMENTS"` renders as `""` when the user passes nothing, which reads as a deliberately empty value. An `<input>` block avoids that, and marks where free text ends
- Keep commands small and focused. If one grows large or sprouts branching logic, suggest moving the procedure into a skill and have the command dispatch to it
  - Personal skills live in `$DEV_DIR/repos/personal/agent-skills`
  - Third-party skills are installed by `Taskfile.yml` into `~/.agents/skills`
- When a command dispatches to a skill, do not restate what the skill already covers - the two copies will drift
- Restrict a command by outcome, not by tool: "do not commit" rather than "do not run git commands", which would also block the `git log` and `git diff` the command needs
- Wrap command files at 80 columns
- When referencing `gh`:
  - Strip a leading `#` before passing a number to `gh`
  - A bare number is ambiguous - GitHub numbers issues and PRs in one sequence
  - `gh api` does not paginate by default; pass `--paginate`
  - Pass `--repo <owner>/<repo>` explicitly - `{owner}`/`{repo}` resolve from the current directory, not from the PR
  - REST `/pulls/<n>/comments` has no resolution state; use GraphQL `reviewThreads`
