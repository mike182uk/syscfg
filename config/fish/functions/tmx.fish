function tmx --description 'Start or attach to a tmux session'
	if pgrep -xq -- "tmux"
		tmux attach
	else
		tmux
	end
end
