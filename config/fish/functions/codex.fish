function codex --wraps codex --description 'Run Codex with the personal profile'
    set --local profile_commands exec e review resume queue archive delete unarchive fork mcp sandbox
    set --local subcommand $argv[1]

    if test -z "$subcommand"
        command codex --profile personal
    else if contains -- $subcommand $profile_commands
        command codex --profile personal $argv
    else if test "$subcommand" = debug; and test "$argv[2]" = prompt-input
        command codex --profile personal $argv
    else if command codex help "$subcommand" >/dev/null 2>&1
        command codex $argv
    else
        command codex --profile personal $argv
    end
end
