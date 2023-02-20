function cdf --description 'cd into the current Finder directory'
	cd $(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')
end
