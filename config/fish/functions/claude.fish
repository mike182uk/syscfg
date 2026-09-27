function claude --wraps claude --description 'Run Claude Code with per-machine additional directories'
    # Mirrors external_directory in opencode.jsonc - settings.json can't read env vars
    set --local dirs
    test -n "$DEV_DIR"; and set --append dirs $DEV_DIR/repos $DEV_DIR/worktrees
    test -n "$SCRATCH_DIR"; and set --append dirs $SCRATCH_DIR

    if test (count $dirs) -eq 0
        command claude $argv
        return
    end

    set --local json (string join ',' (printf '"%s"\n' $dirs))
    command claude --settings "{\"permissions\":{\"additionalDirectories\":[$json]}}" $argv
end
