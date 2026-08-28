function zed --wraps zed --description 'Run zed with the classic open behaviour: new window per directory, focus the existing window if that directory is already open'
	command zed --classic $argv
end
