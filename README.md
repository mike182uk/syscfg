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
sudo apt-get install -y build-essential bubblewrap
```

### Install `task`

```sh
brew install go-task/tap/go-task
```

## Setup

Clone this repo via `https` instead of `ssh` as SSH keys are not yet set up:

```sh
mkdir -p ~/Developer/repos/personal
git clone https://github.com/mike182uk/syscfg.git ~/Developer/repos/personal/syscfg
```

Copy `.env.example` to `.env` and update the values:

```sh
cd ~/Developer/repos/personal/syscfg && cp .env.example .env
```

Run `task` to see available tasks:

```sh
task
```

## Recommended Run Order

### macOS

```sh
task brew-install     # Install Homebrew packages (Mac App Store apps will fail until signed in)
task macos            # Set hostname and system preferences
```

Open 1Password, sign in, and enable SSH agent (`Settings` > `Developer` > `SSH Agent`)

```sh
task 1password-ssh
task ssh
task git              # Run this AFTER 1password-ssh to avoid any SSH issues
task git-gpg          # Optional - requires GIT_SIGNING_KEY in .env
task dev-dirs
task fish
task fish-init
task fish-completions
task mise
task tmux
task starship
task ghostty
task editorconfig
task ripgrep
task bat
task bun
task claude
task codex
task cursor
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

Sign into Mac App Store, then re-run `task brew-install` to install Mac App Store apps

### Linux

macOS only tasks are skipped automatically, so they are omitted below

```sh
task brew-install     # Install Homebrew packages
```

```sh
task ssh
task ssh-key
task git
task gh
task dev-dirs
task fish
task fish-init
task fish-completions
task mise
task tmux
task starship
task editorconfig
task ripgrep
task bat
task bun
task claude
task codex
task opencode
task herdr
task revdiff
task worktrunk
task plannotator
task zsh
task agents
```
