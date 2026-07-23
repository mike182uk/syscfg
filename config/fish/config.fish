# Disable fish greeting

function fish_greeting
	# Do nothing
end

# Prevent fish from shortening the prompt pwd

set --global fish_prompt_pwd_dir_length 0

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

set --global fish_color_autosuggestion brblack
set --global fish_color_cancel 'red --reverse'
set --global fish_color_command blue
set --global fish_color_comment brblack
set --global fish_color_end white
set --global fish_color_error red
set --global fish_color_escape white
set --global fish_color_history_current magenta
set --global fish_color_keyword cyan
set --global fish_color_normal white
set --global fish_color_operator green
set --global fish_color_option yellow
set --global fish_color_param cyan
set --global fish_color_quote cyan
set --global fish_color_redirection white
set --global fish_color_search_match 'white --reverse'
set --global fish_color_selection 'white --reverse'
set --global fish_color_valid_path green

set --global fish_pager_color_background ''
set --global fish_pager_color_completion white
set --global fish_pager_color_description magenta
set --global fish_pager_color_prefix white
set --global fish_pager_color_progress yellow

set --global fish_pager_color_secondary_background ''
set --global fish_pager_color_secondary_completion white
set --global fish_pager_color_secondary_description magenta
set --global fish_pager_color_secondary_prefix white

set --global fish_pager_color_selected_background 'white --reverse'
set --global fish_pager_color_selected_completion white
set --global fish_pager_color_selected_description white
set --global fish_pager_color_selected_prefix white

set --global fish_color_status magenta
set --global fish_color_cwd green
set --global fish_color_cwd_root green
set --global fish_color_host white
set --global fish_color_host_remote white
set --global fish_color_user white

# Set key bindings

bind shift-up beginning-of-line   # Shift + Up Arrow - Move to the beginning of the line
bind shift-down end-of-line       # Shift + Down Arrow - Move to the end of the line

# Allow scrolling with mouse in less, bat etc. when using tmux

set --global LESS '--mouse'

# Init paths

fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.bun/bin"

# Init homebrew

set --global --export HOMEBREW_NO_ANALYTICS 1
set --global --export HOMEBREW_NO_INSECURE_REDIRECT 1
set --global --export HOMEBREW_CASK_OPTS --require-sha
set --global --export HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS 1

for brew_path in /opt/homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin/brew
	if test -x $brew_path
		$brew_path shellenv | source
		break
	end
end

# Init editor

if command -v zed > /dev/null
	set --global --export EDITOR 'zed --wait'
else
	set --global --export EDITOR 'vim'
end

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

# Init ripgrep

set --global --export RIPGREP_CONFIG_PATH $HOME/.config/ripgrep/config

# Init abbreviations

abbr --add cat 'bat'
abbr --add ls 'eza'
if command -v trash > /dev/null
	abbr --add rm 'trash'
end

abbr --add brwe 'brew'
abbr --add b 'brew'
abbr --add c 'cursor'
abbr --add d 'docker'
abbr --add dc 'docker-compose'
abbr --add e "$EDITOR"
abbr --add g 'git'
abbr --add l 'eza -lga --git --group-directories-first'
abbr --add lzd 'lazydocker'
abbr --add lzg 'lazygit'
abbr --add oc 'opencode'
if test -x /Applications/Tailscale.app/Contents/MacOS/Tailscale
	abbr --add ts '/Applications/Tailscale.app/Contents/MacOS/Tailscale'
end

abbr --add .. 'cd ..'
abbr --add ... 'cd ../..'
abbr --add .... 'cd ../../..'
abbr --add ..... 'cd ../../../..'
abbr --add h 'cd ~'
abbr --add dl 'cd ~/Downloads'
abbr --add dv 'cd ~/Developer'

abbr --add hp 'herdr session attach personal'
abbr --add hw 'herdr session attach work'

# Load local config

if test -f $__fish_config_dir/config.local.fish
	source $__fish_config_dir/config.local.fish
end

# Load select environment variables from syscfg .env

set --local syscfg_env $HOME/Developer/repos/personal/syscfg/.env
set --local syscfg_env_allow EXA_API_KEY HEVY_API_KEY

if test -f $syscfg_env
	for line in (string match --invert --regex '^\s*(#|$)' < $syscfg_env)
		set --local kv (string split --max 1 '=' -- $line)
		if contains -- $kv[1] $syscfg_env_allow
			set --global --export $kv[1] (string trim --chars '"\'' -- $kv[2])
		end
	end
end
