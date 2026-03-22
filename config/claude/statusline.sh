#!/usr/bin/env bash

# https://docs.anthropic.com/en/docs/claude-code/statusline

# Example input:
# {
#   "cwd": "/current/working/directory",
#   "session_id": "abc123...",
#   "transcript_path": "/path/to/transcript.jsonl",
#   "model": {
#     "id": "claude-opus-4-6",
#     "display_name": "Opus"
#   },
#   "workspace": {
#     "current_dir": "/current/working/directory",
#     "project_dir": "/original/project/directory"
#   },
#   "version": "1.0.80",
#   "output_style": {
#     "name": "default"
#   },
#   "cost": {
#     "total_cost_usd": 0.01234,
#     "total_duration_ms": 45000,
#     "total_api_duration_ms": 2300,
#     "total_lines_added": 156,
#     "total_lines_removed": 23
#   },
#   "context_window": {
#     "total_input_tokens": 15234,
#     "total_output_tokens": 4521,
#     "context_window_size": 200000,
#     "used_percentage": 8,
#     "remaining_percentage": 92,
#     "current_usage": {
#       "input_tokens": 8500,
#       "output_tokens": 1200,
#       "cache_creation_input_tokens": 5000,
#       "cache_read_input_tokens": 2000
#     }
#   },
#   "exceeds_200k_tokens": false,
#   "rate_limits": {
#     "five_hour": {
#       "used_percentage": 23.5,
#       "resets_at": 1738425600
#     },
#     "seven_day": {
#       "used_percentage": 41.2,
#       "resets_at": 1738857600
#     }
#   },
#   "vim": {
#     "mode": "NORMAL"
#   },
#   "agent": {
#     "name": "security-reviewer"
#   },
#   "worktree": {
#     "name": "my-feature",
#     "path": "/path/to/.claude/worktrees/my-feature",
#     "branch": "worktree-my-feature",
#     "original_cwd": "/path/to/project",
#     "original_branch": "main"
#   }
# }

input=$(cat)

DIM=$'\033[90m'
RESET=$'\033[0m'
SEPARATOR=" · "

get_project() {
	dir=$(echo "$input" | jq -r '.workspace.project_dir // empty')
	if [ -z "$dir" ]; then
		return
	fi

	branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)

	if [ -n "$branch" ]; then
		echo "${dir}${DIM}:${branch}${RESET}"
	else
		echo "$dir"
	fi
}

get_model() {
	echo "$input" | jq -r '.model.display_name'
}

get_agent() {
	echo "$input" | jq -r '.agent.name // empty'
}

get_context() {
	percent=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

	if [ -z "$percent" ]; then
		return
	fi

	limit_k=$(echo "$input" | jq -r '.context_window.context_window_size / 1000 | floor')
	tokens_k=$(echo "$input" | jq -r '(.context_window.context_window_size * .context_window.used_percentage / 100) / 1000 | floor')

	result="${percent}% ${DIM}(${tokens_k}k/${limit_k}k)${RESET}"
	rate=$(get_rate_limit)
	if [ -n "$rate" ]; then
		result+="${SEPARATOR}${rate} ${DIM}(5h)${RESET}"
	fi

	echo "$result"
}

get_rate_limit() {
	percent=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')

	if [ -z "$percent" ]; then
		return
	fi

	# truncate to integer
	percent=${percent%.*}

	echo "${percent}%"
}

parts=()

project=$(get_project)
if [ -n "$project" ]; then
	parts+=("$project")
fi

agent=$(get_agent)
if [ -n "$agent" ]; then
	parts+=("$agent")
fi

parts+=("$(get_model)")

context=$(get_context)
if [ -n "$context" ]; then
	parts+=("$context")
fi

output=""
for i in "${!parts[@]}"; do
	if [ "$i" -gt 0 ]; then
		output+="${SEPARATOR}"
	fi

	output+="${parts[$i]}"
done

echo "$output"
