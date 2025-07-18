function u --description 'Update system'
	_update_msg "Updating brew..."
	brew update && brew outdated && brew upgrade

	_update_msg "Updating mas..."
	mas outdated && mas upgrade

	_update_msg "Updating fisher..."
	fisher update

	_update_msg "Updating tmux plugins..."
	$HOME/.tmux/plugins/tpm/bin/update_plugins all
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
