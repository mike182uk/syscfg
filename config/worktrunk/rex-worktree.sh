#!/usr/bin/env sh

set -eu

separator=' ⋅ '

die() {
	printf 'rex-worktree: %s\n' "$*" >&2
	exit 1
}

usage() {
	printf 'usage: %s open|close <worktree_path> <branch>\n' "$0" >&2
	exit 2
}

action=${1:-}
worktree_path=${2:-}
branch=${3:-}
case "$action" in
open | close) ;;
*) usage ;;
esac
[ -n "$worktree_path" ] && [ -n "$branch" ] || usage

[ -n "${REX_SESSION:-}" ] || exit 0

for dependency in rex jq; do
	command -v "$dependency" >/dev/null 2>&1 || die "$dependency not found"
done

sessions=$(rex ls --json)

# The project session is the one wt ran from, or the project it belongs to if
# wt ran from one of the project's worktree sessions
current_label=$(
	printf '%s\n' "$sessions" |
		jq -r --arg id "$REX_SESSION" '.sessions[] | select(.session_id == $id) | .label'
)
[ -n "$current_label" ] || die "current session not found: $REX_SESSION"
project_label=${current_label%%"$separator"*}
worktree_label="$project_label$separator$branch"

worktree_session_id=$(
	printf '%s\n' "$sessions" |
		jq -r --arg label "$worktree_label" \
			'[.sessions[] | select(.label == $label)][0].session_id // empty'
)

if [ "$action" = close ]; then
	[ -z "$worktree_session_id" ] || rex kill "$worktree_session_id" >/dev/null
	exit 0
fi

[ -z "$worktree_session_id" ] || exit 0

# Place the new session after the project and any worktree sessions it already has
anchor_id=$(
	printf '%s\n' "$sessions" |
		jq -r --arg project "$project_label" --arg prefix "$project_label$separator" \
			'[.sessions[] | select(.label == $project or (.label | startswith($prefix)))][-1].session_id // empty'
)

worktree_session_id=$(
	rex new "$worktree_label" --cwd "$worktree_path" --json |
		jq -er '.session_id | select(type == "string" and length > 0)'
) || die "created session has no ID"

[ -z "$anchor_id" ] || rex session move "$worktree_session_id" --after "$anchor_id" >/dev/null
