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
#
# ANSI names so the colours follow the terminal palette (see ghostty theme)
#
# https://fishshell.com/docs/current/interactive.html
#
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

# Allow scrolling with mouse in less, bat etc.

set --global --export LESS '--mouse'

# Opt out of telemetry for tools that honour DO_NOT_TRACK

set --global --export DO_NOT_TRACK 1

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
	set --global --export EDITOR 'zed --classic --wait'
else if command -v nvim > /dev/null
	set --global --export EDITOR 'nvim'
else
	set --global --export EDITOR 'vim'
end

# Init fzf

set --global --export FZF_DEFAULT_OPTS_FILE "$HOME/.config/fzf/fzfrc"

# Init fzf.fish

if functions -q fzf_configure_bindings
	fzf_configure_bindings --directory=\cf --git_log=\cg --git_status=\cs --history= --processes=\cp --variables=\cv
end

# Init atuin

if command -v atuin > /dev/null
	atuin init fish --disable-ai --disable-up-arrow | source
end

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

# Init OrbStack

if test -f ~/.orbstack/shell/init2.fish
	source ~/.orbstack/shell/init2.fish 2>/dev/null || :
end

# Init abbreviations

abbr --add cat 'bat'
abbr --add ls 'eza'
if command -v trash > /dev/null
	abbr --add rm 'trash'
end

abbr --add brwe 'brew'
abbr --add b 'brew'
abbr --add d 'docker'
abbr --add dc 'docker-compose'
abbr --add e "$EDITOR"
abbr --add g 'git'
abbr --add l 'eza -lga --git --group-directories-first'
abbr --add oc 'opencode'
abbr --add rd 'revdiff'
abbr --add ts 'tailscale'
abbr --add v 'nvim'
abbr --add vi 'nvim'
abbr --add vim 'nvim'

abbr --add .. 'cd ..'
abbr --add ... 'cd ../..'
abbr --add .... 'cd ../../..'
abbr --add ..... 'cd ../../../..'
abbr --add h 'cd ~'
abbr --add dl 'cd ~/Downloads'
abbr --add dev 'cd $DEV_DIR'
abbr --add sc 'cd $SCRATCH_DIR'

abbr --add hp 'herdr session attach personal'
abbr --add hw 'herdr session attach work'

# Load select environment variables from .env.local

for key in \
	ATUIN_SYNC_ADDRESS \
	DEV_DIR \
	EXECUTOR_URL \
	SCRATCH_DIR
	set --local value (syscfg-env .env.local $key)
	test -n "$value"; and set --global --export $key $value
end
