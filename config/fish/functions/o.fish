function o --argument-names 'filename' --description 'Open the either the provided directory, or the current directory in a Finder window'
	if test -n "$filename"
		open $filename
	else
		open $PWD
	end
end
