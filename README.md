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

Copy `.env.example` to `.env` and update the values:

```sh
cd ~/.syscfg && cp .env.example .env
```

- `DEV_DIR` - Directory to use for repositories & worktrees (must be literal path, vars are not expanded)
- `HOSTNAME` - Desired hostname for the machine (only used during `macos` setup)
- `GIT_USERNAME` - Username for Git user
- `GIT_EMAIL` - Email for Git user
- `GIT_SIGNING_KEY` - Path to GPG signing key for Git
- `GH_TOKEN` - `gh` token
- `CONTEXT7_API_KEY` - Context7 API key
- `EXA_API_KEY` - Exa API key
- `HEVY_API_KEY` - Hevy API key
- `PLEXUS_API_URL` - Plexus API URL
- `PLEXUS_API_KEY` - Plexus API key
- `EXECUTOR_API_URL` - Executor API URL
- `EXECUTOR_API_KEY` - Executor API key

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
task fish
task fish-init
task fish-completions
task mise
task nvim
task starship
task ghostty
task editorconfig
task ripgrep
task bat
task btop
task bun
task claude
task codex
task cursor
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
task fish
task fish-init
task fish-completions
task mise
task nvim
task starship
task editorconfig
task ripgrep
task bat
task btop
task bun
task claude
task codex
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
