#!/usr/bin/env sh

set -eu

die() {
	printf 'herdr-worktree: %s\n' "$*" >&2
	exit 1
}

action=${1:-}
case "$action" in
open | close) ;;
*)
	printf 'usage: %s open|close\n' "$0" >&2
	exit 2
	;;
esac

[ "${HERDR_ENV:-}" = 1 ] || exit 0

for dependency in herdr jq; do
	command -v "$dependency" >/dev/null 2>&1 || die "$dependency not found"
done

context=$(jq -ce .) || die "invalid Worktrunk hook context"
primary_worktree_path=$(
	printf '%s\n' "$context" |
		jq -er '.primary_worktree_path | select(type == "string" and length > 0)'
) || die "primary_worktree_path is missing from the Worktrunk hook context"
worktree_path=$(
	printf '%s\n' "$context" |
		jq -er '.worktree_path | select(type == "string" and length > 0)'
) || die "worktree_path is missing from the Worktrunk hook context"

worktrees=$(herdr worktree list --cwd "$primary_worktree_path")
root_workspace_id=$(
	printf '%s\n' "$worktrees" | jq -r '.result.source.source_workspace_id // empty'
)

if [ "$action" = open ]; then
	worktree=$(
		printf '%s\n' "$worktrees" |
			jq -c --arg path "$worktree_path" \
				'[.result.worktrees[] | select(.path == $path)][0] // empty'
	)
	[ -n "$worktree" ] || die "worktree not found: $worktree_path"

	open_workspace_id=$(
		printf '%s\n' "$worktree" | jq -r '.open_workspace_id // empty'
	)
	[ -z "$open_workspace_id" ] || exit 0

	if [ -z "$root_workspace_id" ]; then
		root_workspace=$(herdr workspace create --cwd "$primary_worktree_path" --no-focus)
		root_workspace_id=$(
			printf '%s\n' "$root_workspace" |
				jq -er '.result.workspace.workspace_id | select(type == "string" and length > 0)'
		) || die "created root workspace has no ID"
	fi

	herdr worktree open \
		--workspace "$root_workspace_id" \
		--path "$worktree_path" \
		--no-focus >/dev/null
	exit 0
fi

workspaces=$(herdr workspace list)
worktree_workspace=$(
	printf '%s\n' "$workspaces" |
		jq -c --arg path "$worktree_path" \
			'[.result.workspaces[] | select(
				.worktree.is_linked_worktree == true and
				.worktree.checkout_path == $path
			)][0] // empty'
)
[ -n "$worktree_workspace" ] || exit 0

worktree_workspace_id=$(
	printf '%s\n' "$worktree_workspace" | jq -r '.workspace_id'
)
worktree_workspace_focused=$(
	printf '%s\n' "$worktree_workspace" | jq -r '.focused'
)

if [ "$worktree_workspace_focused" = true ]; then
	[ -n "$root_workspace_id" ] || die "root workspace not found"
	root_active_tab_id=$(
		printf '%s\n' "$workspaces" |
			jq -r --arg id "$root_workspace_id" \
				'[.result.workspaces[] | select(.workspace_id == $id)][0].active_tab_id // empty'
	)
	[ -n "$root_active_tab_id" ] || die "root workspace has no active tab: $root_workspace_id"
	herdr tab focus "$root_active_tab_id" >/dev/null
fi

herdr workspace close "$worktree_workspace_id" >/dev/null
