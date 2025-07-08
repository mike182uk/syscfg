function attn --description 'Notify user attention is required'
	afplay /System/Library/Sounds/Funk.aiff >/dev/null 2>&1 &; disown
end
