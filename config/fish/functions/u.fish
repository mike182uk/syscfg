function u --description 'Update system'
	if command -v brew > /dev/null
		# Authorize the 1Password SSH agent up front - git rewrites
		# github.com to SSH, so brew fetches taps over SSH
		if test -S $HOME/.1password/agent.sock
			ssh -T git@github.com 2>&1 | string match --quiet --entire 'successfully authenticated'; or return 1
		end

		_update_msg "Updating brew..."
		brew update && brew outdated && brew upgrade --yes
	end

	if command -v mas > /dev/null
		_update_msg "Updating mas..."
		mas outdated && mas upgrade
	end

	_update_msg "Updating fisher..."
	fisher update

	_update_msg "Updating tmux plugins..."
	$HOME/.tmux/plugins/tpm/bin/update_plugins all

	_update_msg "Updating misc programs..."
	mise upgrade opencode
	echo ""
	claude update
	echo ""
	bun add -g agent-browser@latest opensrc@latest

	_update_msg "Updating agent skills..."
	bunx skills@latest update --global
end

function _update_msg
	echo ""
	set_color magenta
	echo "================================================"
	echo $argv
	echo "================================================"
	set_color normal
	echo ""
end
