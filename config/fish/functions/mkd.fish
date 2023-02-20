function mkd --description 'Create a new directory and cd into it'
	mkdir -p $argv && cd $argv[-1]
end
