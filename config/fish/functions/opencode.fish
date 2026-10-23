function opencode --wraps opencode --description 'Run OpenCode with required env vars'
	EXECUTOR_TOKEN_OC=(syscfg-env .env EXECUTOR_TOKEN_OC) command opencode $argv
end
