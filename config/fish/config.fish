# Init homebrew

set --global --export HOMEBREW_NO_ANALYTICS 1
set --global --export HOMEBREW_NO_INSECURE_REDIRECT 1
set --global --export HOMEBREW_CASK_OPTS --require-sha

/opt/homebrew/bin/brew shellenv | source

# Init editor

set --global --export EDITOR 'zed --wait'

# Init fnm

fnm env | source

# Init fzf.fish

fzf_configure_bindings --directory=\cf --git_log=\cg --git_status=\cs --processes=\cp --variables=\cv

# Init go

set --local gopath $HOME/.go

if test -d $gopath
	set --global --export GOPATH $gopath
	set --global --export GOBIN $gopath/bin

	fish_add_path --path $gopath/bin
end

# Init rust

fish_add_path --path $HOME/.cargo/bin

# Init ssh

if test -e $HOME/.1password/agent.sock
	set --global --export SSH_AUTH_SOCK $HOME/.1password/agent.sock
end

# Init abbreviations

abbr --add cat 'bat'
abbr --add ls 'eza'
abbr --add nvm 'fnm'
abbr --add rm 'trash'
abbr --add brwe 'brew'

abbr --add d 'docker'
abbr --add dc 'docker-compose'
abbr --add e "$EDITOR"
abbr --add g 'git'
abbr --add l 'eza -lga --git --group-directories-first'
abbr --add lzd 'lazydocker'

abbr --add .. 'cd ..'
abbr --add ... 'cd ../..'
abbr --add .... 'cd ../../..'
abbr --add ..... 'cd ../../../..'
abbr --add h 'cd ~'
abbr --add dl 'cd ~/Downloads'
abbr --add p 'cd ~/Projects'

# Load local config

source $__fish_config_dir/config.local.fish
