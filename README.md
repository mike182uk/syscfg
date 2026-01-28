# syscfg

Everything I need to set up a new macOS based system

## Prerequisites

- [Git](https://git-scm.com/)
- [Homebrew](https://brew.sh/)
- [Task](https://taskfile.dev/#/installation)

#### Install `homebrew`

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Install `task`

```sh
/opt/homebrew/bin/brew install go-task/tap/go-task
```

## Setup

Clone this repo via `https` instead of `ssh` as SSH keys are not yet setup

```sh
git clone https://github.com/mike182uk/syscfg.git
```

Copy `.env.example` to `.env` and update the values

```sh
cd syscfg && cp .env.example .env
```

Run `task` to see available tasks

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"

task
```

## Recommended Run Order

```sh
task brew-install     # Install Homebrew packages (Mac App Store apps will fail until signed in)
task macos            # Set hostname, default shell, and system preferences
```

Open 1Password, sign in, and enable SSH agent (Settings > Developer > SSH Agent)

```sh
task 1password-ssh
task ssh
task git              # Run this AFTER 1password-ssh to avoid SSH issues
task git-gpg          # Optional - requires GIT_SIGNING_KEY in .env
task fish
task fish-init
task fish-completions
task mise
task tmux
task starship
task ghostty
task editorconfig
task bun
task claude
task cursor
task sublime-text
task zed
task opencode
task raycast
task zsh
task agents
```

Sign into Mac App Store, then re-run `task brew-install` to install Mac App Store apps
