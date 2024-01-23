# Disable fish greeting

function fish_greeting
	# Do nothing
end

# Prevent fish from shortening the prompt pwd

set --global --export fish_prompt_pwd_dir_length 0

# Set the terminal title

function fish_title
	echo $argv[1] (prompt_pwd)
end

# Add newline before prompt but only when previous output exists
#	https://stackoverflow.com/questions/65722822/fish-shell-add-newline-before-prompt-only-when-previous-output-exists
function add_newline_before_prompt_maybe --on-event fish_postexec
	echo
end

# Init homebrew

set --global --export HOMEBREW_NO_ANALYTICS 1
set --global --export HOMEBREW_NO_INSECURE_REDIRECT 1
set --global --export HOMEBREW_CASK_OPTS --require-sha

/opt/homebrew/bin/brew shellenv | source

# Init asdf

if command -v asdf > /dev/null
	source $(brew --prefix asdf)/libexec/asdf.fish
end

# Init editor

set --global --export EDITOR 'zed --wait'

# Init fzf.fish

fzf_configure_bindings --directory=\cf --git_log=\cg --git_status=\cs --processes=\cp --variables=\cv

# Init go

if test -e $HOME/.asdf/plugins/golang/set-env.fish
	source $HOME/.asdf/plugins/golang/set-env.fish
end

set --global --export ASDF_GOLANG_MOD_VERSION_ENABLED true

# Init starship

if command -v starship > /dev/null
	starship init fish | source
end

# Init ssh

if test -e $HOME/.1password/agent.sock
	set --global --export SSH_AUTH_SOCK $HOME/.1password/agent.sock
end

# Init abbreviations

abbr --add cat 'bat'
abbr --add ls 'eza'
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
