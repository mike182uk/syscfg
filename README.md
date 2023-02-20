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
brew install go-task/tap/go-task
```

## Setup

Clone this repo

```sh
git clone git@github.com:mike182uk/syscfg.git
```

Copy `.env.example` to `.env` and update the values

```sh
cd syscfg && cp .env.example .env
```

Run `task` to see available tasks

```sh
task
```
