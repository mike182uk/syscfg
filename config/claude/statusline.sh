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
#   }
# }

input=$(cat)

CONTEXT_LIMIT=200000

DIM=$'\033[90m'
RESET=$'\033[0m'
SEPARATOR=" / "

get_model() {
	echo "$input" | jq -r '.model.display_name'
}

get_duration() {
	duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms')

	if [[ "$duration_ms" =~ ^[0-9]+$ ]] && [ "$duration_ms" -gt 0 ]; then
		# Round up to nearest minute
		duration_m=$(((duration_ms + 59999) / 60000))
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
		# Round up to nearest cent
		cost=$(awk "BEGIN {printf \"%.2f\", int($cost * 100 + 0.99) / 100}")
	fi

	echo "\$${cost}"
}

get_context_tokens() {
	transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

	if [ -z "$transcript_path" ] || [ ! -f "$transcript_path" ]; then
		echo "0"
		return
	fi

	# Get the last assistant message's usage from the transcript
	# Total context = input_tokens + cache_creation_input_tokens + cache_read_input_tokens
	usage=$(tail -20 "$transcript_path" 2>/dev/null |
		jq -s '[.[] | select(.type == "assistant") | .message.usage] | last // empty' 2>/dev/null)

	if [ -z "$usage" ] || [ "$usage" = "null" ]; then
		echo "0"
		return
	fi

	input_tokens=$(echo "$usage" | jq -r '.input_tokens // 0')
	cache_creation=$(echo "$usage" | jq -r '.cache_creation_input_tokens // 0')
	cache_read=$(echo "$usage" | jq -r '.cache_read_input_tokens // 0')

	echo $((input_tokens + cache_creation + cache_read))
}

get_context_percent() {
	local tokens=$1

	if [ "$tokens" -gt 0 ]; then
		# Round up to nearest percent
		echo $(((tokens * 100 + CONTEXT_LIMIT - 1) / CONTEXT_LIMIT))
	else
		echo "0"
	fi
}

get_context_count() {
	local tokens=$1

	if [ "$tokens" -gt 0 ]; then
		# Format as Xk (round up)
		total_k=$(((tokens + 999) / 1000))
		limit_k=$((CONTEXT_LIMIT / 1000))

		echo "${total_k}k/${limit_k}k"
	else
		echo "0k/$((CONTEXT_LIMIT / 1000))k"
	fi
}

context_tokens=$(get_context_tokens)

echo "$(get_model)${SEPARATOR}$(get_duration)${SEPARATOR}$(get_cost)${SEPARATOR}$(get_context_percent "$context_tokens")% ${DIM}($(get_context_count "$context_tokens"))${RESET}"
