function attn --description 'Notify user attention is required'
	if command -v afplay > /dev/null
		afplay /System/Library/Sounds/Funk.aiff >/dev/null 2>&1 &; disown
	end
end
