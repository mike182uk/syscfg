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

# Set colors
# https://fishshell.com/docs/current/interactive.html
# To see all colors set: set -n | grep color

set --global --export fish_color_autosuggestion brblack
set --global --export fish_color_cancel red --reverse
set --global --export fish_color_command blue
set --global --export fish_color_comment brblack
set --global --export fish_color_end white
set --global --export fish_color_error red
set --global --export fish_color_escape white
set --global --export fish_color_history_current magenta
set --global --export fish_color_keyword cyan
set --global --export fish_color_normal white
set --global --export fish_color_operator green
set --global --export fish_color_option yellow
set --global --export fish_color_param cyan
set --global --export fish_color_quote cyan
set --global --export fish_color_redirection white
set --global --export fish_color_search_match white --reverse
set --global --export fish_color_selection white --reverse
set --global --export fish_color_valid_path green

set --global --export fish_pager_color_background
set --global --export fish_pager_color_completion white
set --global --export fish_pager_color_description magenta
set --global --export fish_pager_color_prefix white
set --global --export fish_pager_color_progress yellow

set --global --export fish_pager_color_secondary_background
set --global --export fish_pager_color_secondary_completion white
set --global --export fish_pager_color_secondary_description magenta
set --global --export fish_pager_color_secondary_prefix white

set --global --export fish_pager_color_selected_background white --reverse
set --global --export fish_pager_color_selected_completion white
set --global --export fish_pager_color_selected_description white
set --global --export fish_pager_color_selected_prefix white

set --global --export fish_color_status magenta
set --global --export fish_color_cwd green
set --global --export fish_color_cwd_root green
set --global --export fish_color_host white
set --global --export fish_color_host_remote white
set --global --export fish_color_user white

# Set key bindings

bind -k sr beginning-of-line # Shift + Up Arrow - Move to the beginning of the line
bind -k sf end-of-line       # Shift + Down Arrow - Move to the end of the line

# Allow scrolling with mouse in less, bat etc. when using tmux

set --global --export LESS '--mouse'

# Init paths

fish_add_path ~/.local/bin

# Init homebrew

set --global --export HOMEBREW_NO_ANALYTICS 1
set --global --export HOMEBREW_NO_INSECURE_REDIRECT 1
set --global --export HOMEBREW_CASK_OPTS --require-sha

/opt/homebrew/bin/brew shellenv | source

# Init editor

set --global --export EDITOR 'zed --wait'

# Init fzf

set --global --export FZF_DEFAULT_OPTS '
	--color=fg:-1,fg+:-1,bg:-1,bg+:-1
	--color=hl:5,hl+:5,info:3,marker:2
	--color=prompt:4,spinner:3,pointer:5:bold,header:8:bold
	--color=border:8,label:7,query:7
	--border --cycle --layout=reverse --info=inline-right --marker=*
'

# Init fzf.fish

fzf_configure_bindings --directory=\cf --git_log=\cg --git_status=\cs --processes=\cp --variables=\cv

# Init starship

if command -v starship > /dev/null
	starship init fish | source
end

# Init ssh

if test -e $HOME/.1password/agent.sock
	set --global --export SSH_AUTH_SOCK $HOME/.1password/agent.sock
end

# Init zoxide

if command -v zoxide > /dev/null
	zoxide init fish | source
end

# Init abbreviations

abbr --add cat 'bat'
abbr --add ls 'eza'
abbr --add rm 'trash'
abbr --add brwe 'brew'
abbr --add /claude 'claude'
abbr --add cluade 'claude'

abbr --add b 'brew'
abbr --add c 'cursor'
abbr --add d 'docker'
abbr --add dc 'docker-compose'
abbr --add e "$EDITOR"
abbr --add g 'git'
abbr --add l 'eza -lga --git --group-directories-first'
abbr --add lzd 'lazydocker'
abbr --add ts '/Applications/Tailscale.app/Contents/MacOS/Tailscale'

abbr --add .. 'cd ..'
abbr --add ... 'cd ../..'
abbr --add .... 'cd ../../..'
abbr --add ..... 'cd ../../../..'
abbr --add h 'cd ~'
abbr --add dl 'cd ~/Downloads'
abbr --add p 'cd ~/Projects'

# Load local config

source $__fish_config_dir/config.local.fish
