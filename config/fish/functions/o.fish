function o --argument-names 'filename' --description 'Open either the provided directory, or the current directory, in a Finder window'
	if not command -v open > /dev/null
		echo "o: only supported on macOS (requires Finder)" >&2
		return 1
	end

	if test -n "$filename"
		open $filename
	else
		open $PWD
	end
end
