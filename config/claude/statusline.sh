#!/usr/bin/env bash

# https://docs.anthropic.com/en/docs/claude-code/statusline

# Example input:
# {
#   "hook_event_name": "Status",
#   "session_id": "abc123...",
#   "transcript_path": "/path/to/transcript.json",
#   "cwd": "/current/working/directory",
#   "model": {
#     "id": "claude-opus-4-1",
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
#     "current_usage": {
#       "input_tokens": 8500,
#       "output_tokens": 1200,
#       "cache_creation_input_tokens": 5000,
#       "cache_read_input_tokens": 2000
#     }
#   }
# }

input=$(cat)

DIM=$'\033[90m'
RESET=$'\033[0m'
SEPARATOR=" / "

get_model() {
	echo "$input" | jq -r '.model.display_name'
}

get_duration() {
	duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms')

	if [[ "$duration_ms" =~ ^[0-9]+$ ]] && [ "$duration_ms" -gt 0 ]; then
		duration_m=$((duration_ms / 60000))
		duration_h=$((duration_m / 60))
		duration_m=$((duration_m % 60))
		duration_format=""

		if [ "$duration_h" -gt 0 ]; then
			duration_format="${duration_h}h "
		fi

		duration_format="${duration_format}${duration_m}m"
		duration="$duration_format"
	else
		duration="0m"
	fi

	echo "$duration"
}

get_cost() {
	cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

	if [ -z "$cost" ] || [ "$cost" = "null" ] || [ "$cost" = "0" ]; then
		cost="0.00"
	else
		cost=$(awk "BEGIN {printf \"%.2f\", int($cost * 100) / 100}")
	fi

	echo "\$${cost}"
}

get_context() {
	limit=$(echo "$input" | jq -r '.context_window.context_window_size')
	usage=$(echo "$input" | jq '.context_window.current_usage')

	if [ "$usage" = "null" ]; then
		return
	fi

	tokens=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
	percent=$((tokens * 100 / limit))
	tokens_k=$((tokens / 1000))
	limit_k=$((limit / 1000))

	echo "${percent}% ${DIM}(${tokens_k}k/${limit_k}k)${RESET}"
}

context=$(get_context)

if [ -n "$context" ]; then
	echo "$(get_model)${SEPARATOR}$(get_duration)${SEPARATOR}$(get_cost)${SEPARATOR}${context}"
else
	echo "$(get_model)${SEPARATOR}$(get_duration)"
fi
