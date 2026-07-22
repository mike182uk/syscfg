function u --description 'Update system'
	if command -v brew > /dev/null
		# Trigger 1Password authentication before attempting to update brew on macOS
		if command -v op > /dev/null
			op vault list >/dev/null 2>&1; or return 1
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
	mise upgrade github:anomalyco/opencode
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
