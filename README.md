# syscfg

Everything I need to set up a new macOS / Linux based system

## Prerequisites

- [Git](https://git-scm.com/)
- [Homebrew](https://brew.sh/)
- [Task](https://taskfile.dev/#/installation)

### Install `homebrew`

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

```sh
# macOS
eval "$(/opt/homebrew/bin/brew shellenv)"

# Linux
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
sudo apt-get install -y build-essential
```

### Install `task`

```sh
brew install go-task
```

## Setup

Clone this repo via `https` instead of `ssh` as SSH keys are not yet set up:

```sh
git clone https://github.com/mike182uk/syscfg.git ~/.syscfg
```

Copy `.env.local.example` to `.env.local` and update the values. These are not secret and are loaded by every task and fish shell:

```sh
cd ~/.syscfg && cp .env.local.example .env.local
```

- `DEV_DIR` - Directory to use for repositories & worktrees (must be literal path, vars are not expanded)
- `SCRATCH_DIR` - Directory to use for scratch space (must be literal path, vars are not expanded)
- `HOSTNAME` - Desired hostname for the machine (only used during `macos` setup)
- `GIT_USERNAME` - Username for Git user
- `GIT_EMAIL` - Email for Git user
- `GIT_SIGNING_KEY` - Path to GPG signing key for Git
- `ATUIN_SYNC_ADDRESS` - Atuin sync server URL
- `EXECUTOR_URL` - Executor API URL

Secrets go in `.env`, mounted from a [1Password Environment](https://developer.1password.com/docs/environments/local-env-file/) using the variables in `.env.example`:

- `GH_TOKEN` - `gh` token
- `GH_COPILOT_TOKEN` - GitHub Copilot token, used to sign in to Copilot automatically. Copy it from a machine that is already signed in:
  `sqlite3 ~/.config/github-copilot/auth.db "select cast(token_ciphertext as text) from oauth_tokens limit 1"`
- `EXECUTOR_TOKEN_CC` - Executor API key (Claude Code)
- `EXECUTOR_TOKEN_OC` - Executor API key (OpenCode)

Run `task` to see available tasks:

```sh
task
```

## Recommended Run Order

### macOS

```sh
task brew-install     # Mac App Store apps will fail until signed in
task macos
```

Open 1Password, sign in, and enable SSH agent (`Settings` > `Developer` > `SSH Agent`)

```sh
task 1password-ssh
task ssh
task git
task git-gpg          # Requires GIT_SIGNING_KEY
task dev-dirs
task scratch-dir
task bin
task fish
task fish-init
task mise
task go
task nvim
task starship
task ghostty
task editorconfig
task ripgrep
task bat
task btop
task fzf
task atuin
task bun
task agent-browser
task claude
task sublime-text
task zed
task opencode
task herdr
task revdiff          # Requires GitHub auth or GH_TOKEN
task worktrunk
task plannotator      # Requires GitHub auth or GH_TOKEN
task raycast
task zsh
task agents           # Requires GitHub auth or GH_TOKEN
```

To install Mac App Store apps, sign into Mac App Store, then re-run: 

```sh
task brew-install
```

### Linux

```sh
task brew-install
task ssh
task ssh-key
task git
task gh
task dev-dirs
task scratch-dir
task bin
task fish
task fish-init
task mise
task go
task nvim
task starship
task editorconfig
task ripgrep
task bat
task btop
task fzf
task atuin
task bun
task agent-browser
task claude
task opencode
task herdr
task revdiff         # Requires GitHub auth or GH_TOKEN
task worktrunk
task plannotator     # Requires GitHub auth or GH_TOKEN
task zsh
task agents          # Requires GitHub auth or GH_TOKEN
```

or you can run everything in one go with:

```sh
task setup-linux
```
