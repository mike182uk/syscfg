# syscfg

Everything I need to set up a new macOS / Linux based system

## Prerequisites

- [Git](https://git-scm.com/)
- [1Password](https://1password.com/)
- [Homebrew](https://brew.sh/)
- [Task](https://taskfile.dev/#/installation)

### Install `homebrew`

```sh
sudo -v && NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
- `GIT_SIGNING_KEY` - Public SSH key from 1Password used to sign commits (macOS only - Linux signs with `~/.ssh/id_ed25519`)
- `ATUIN_SYNC_ADDRESS` - Atuin sync server URL
- `EXECUTOR_URL` - Executor URL

Secrets go in `.env`, using the variables in `.env.example`. With the 1Password desktop app, mount it from a [1Password Environment](https://developer.1password.com/docs/environments/local-env-file/). Without it (e.g. a headless VM), create it as a regular file and restrict it to your user:

```sh
cp .env.example .env && chmod 600 .env
```

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
gh auth login
task macos
```

Open 1Password, sign in, and enable SSH agent (`Settings` > `Developer` > `SSH Agent`)

```sh
task 1password-ssh
task ssh
task git
task git-signing
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
task claude
task sublime-text
task zed
task opencode
task herdr
task revdiff
task worktrunk
task plannotator
task raycast
task zsh
task agents
```

To install Mac App Store apps, sign into Mac App Store, then re-run: 

```sh
task brew-install
```

### Linux

```sh
task brew-install
task ssh
task ssh-key           # Add the printed key on GitHub twice: as an authentication key and a signing key
gh auth login          # Choose SSH, and skip uploading a key
task git
task git-signing
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
task claude
task opencode
task herdr
task revdiff
task worktrunk
task plannotator
task zsh
task agents
```

or you can run everything in one go with:

```sh
task setup-linux
```
