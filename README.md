# syscfg

Everything I need to set up a new macOS workstation, or a headless Linux (Debian / Ubuntu) machine

## Prerequisites

- [Git](https://git-scm.com/)
- [Homebrew](https://brew.sh/)
- [Task](https://taskfile.dev/#/installation)

### Install `git`

On macOS, `git` is installed with the Xcode Command Line Tools during the Homebrew install. On Linux it is usually pre-installed (otherwise install with: `sudo apt-get install -y git`)

### Install `homebrew`

```sh
sudo -v && NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

`sudo -v` asks for your password up front. With `NONINTERACTIVE=1` the installer won't prompt for it, and it needs `sudo` to create the Homebrew directories

#### macOS

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
```

#### Linux

```sh
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

```sh
sudo apt-get install -y build-essential
```

The `eval` only applies to the current shell. Once the full setup is complete, the `brew` command will be available in all shells

### Install `task`

```sh
brew install go-task
```

## Setup

Clone this repo via `https` instead of `ssh` (as SSH keys are not yet set up):

```sh
git clone https://github.com/mike182uk/syscfg.git ~/.syscfg
```

Copy `.env.local.example` to `.env.local` and update the values. These are not secret. Every task loads them, and fish shells export `DEV_DIR`, `SCRATCH_DIR`, `ATUIN_SYNC_ADDRESS` and `EXECUTOR_URL`:

```sh
cd ~/.syscfg && cp .env.local.example .env.local
```

- `DEV_DIR` - Directory to use for repositories & worktrees (must be literal path, vars are not expanded)
- `SCRATCH_DIR` - Directory to use for scratch space (must be literal path, vars are not expanded)
- `MACOS_HOSTNAME` - Desired hostname for the Mac (only used by `task macos`)
- `GIT_USERNAME` - Username for Git user
- `GIT_EMAIL` - Email for Git user
- `GIT_SIGNING_KEY` - Public SSH key from 1Password used to sign commits (macOS only, added in step 4 of the macOS run order - Linux signs with `~/.ssh/id_ed25519`)
- `ATUIN_SYNC_ADDRESS` - Atuin sync server URL
- `EXECUTOR_URL` - Executor URL

Secrets go in `.env`, using the variables in `.env.example`. On macOS, it is mounted from a [1Password Environment](https://developer.1password.com/docs/environments/local-env-file/) at `~/.syscfg/.env` in step 4 of the macOS run order. On Linux, create it as a regular file and restrict it to your user:

```sh
cp .env.example .env && chmod 600 .env
```

- `EXECUTOR_TOKEN_CC` - Executor API key (Claude Code)
- `EXECUTOR_TOKEN_OC` - Executor API key (OpenCode)

Run `task` to see available tasks:

```sh
task
```

## Recommended run order

### macOS

1. Install system dependencies:

```sh
task brew-install
```

Mac App Store apps will fail to install until you are signed in to your Apple account

2. Set up GitHub authentication:

```sh
gh auth login
```

Choose SSH, and don't generate or upload a key (SSH keys are managed by 1Password)

3. Set up macOS system settings:

```sh
task macos
```

4. Open 1Password (installed by `task brew-install`), sign in, and:
   - enable the SSH agent (`Settings` > `Developer` > `SSH Agent`)
   - mount the 1Password Environment at `~/.syscfg/.env`
   - copy your SSH key's public key into `GIT_SIGNING_KEY` in `.env.local`

5. Run the remaining tasks:

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

To install Mac App Store apps, sign into your Apple account, then re-run:

```sh
task brew-install
```

### Linux

1. Install system dependencies:

```sh
task brew-install
```

2. Set up SSH:

```sh
task ssh
```

```sh
task ssh-key
```

3. Add the printed SSH key at [github.com/settings/ssh/new](https://github.com/settings/ssh/new) twice: once as an authentication key and once as a signing key

4. Set up GitHub authentication:

```sh
gh auth login
```

Choose SSH, and don't generate or upload a key (the key was added to GitHub in step 3)

5. Run the remaining tasks:

```sh
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

Alternatively, after step 4, run all the tasks in one go with:

```sh
task setup-linux
```

## Manual steps

### Enable GitHub Copilot in `nvim`

Open a file in any git repo (e.g. `nvim ~/.syscfg/README.md`), then run:

```vim
:LspCopilotSignIn
```
