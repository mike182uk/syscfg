function codex --wraps codex --description 'Run Codex with the personal profile'
    set --local profile_commands exec e review resume queue archive delete unarchive fork mcp sandbox
    set --local subcommand $argv[1]

    # Mirrors external_directory in opencode.jsonc - Codex config can't read env vars
    set --local roots $HOME/.opensrc
    test -n "$DEV_DIR"; and set --append roots $DEV_DIR/repos $DEV_DIR/worktrees
    test -n "$SCRATCH_DIR"; and set --append roots $SCRATCH_DIR
    set --local profile --profile personal \
        -c "permissions.workspace-no-env.workspace_roots={"(string join ', ' (printf '"%s"=true\n' $roots))"}"

    if test -z "$subcommand"
        command codex $profile
    else if contains -- $subcommand $profile_commands
        command codex $profile $argv
    else if test "$subcommand" = debug; and test "$argv[2]" = prompt-input
        command codex $profile $argv
    else if command codex help "$subcommand" >/dev/null 2>&1
        command codex $argv
    else
        command codex $profile $argv
    end
end
