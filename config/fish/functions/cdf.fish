function cdf --description 'cd into the current Finder directory'
	if not command -v osascript > /dev/null
		echo "cdf: only supported on macOS (requires Finder)" >&2
		return 1
	end
	cd $(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')
end
