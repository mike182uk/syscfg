#!/usr/bin/env sh

# setup-exe-dev.sh
#
# Configure exe.dev-specific VM settings. No-op on machines that are not
# exe.dev VMs (detected via the /exe.dev marker).

set -eu

[ -e /exe.dev ] || {
	echo "not an exe.dev VM; skipping exe.dev setup" >&2
	exit 0
}

CODEX_CONFIG="$HOME/.codex/config.toml"
CODEX_PROVIDER="exe-llm"

# Point Codex at the exe.dev LLM gateway (backed by a connected ChatGPT
# subscription) as its model provider. The gateway authenticates the VM at the
# edge, so no OpenAI key is stored on the box.
#
# The config is merged idempotently: `model_provider` must be a top-level key
# (before any table header), and the provider table is appended. Existing
# content is preserved.
mkdir -p "$(dirname "$CODEX_CONFIG")"
touch "$CODEX_CONFIG"

if ! grep -q "^\[model_providers\.\"$CODEX_PROVIDER\"\]" "$CODEX_CONFIG"; then
	tmp=$(mktemp)
	trap 'rm -f "$tmp"' EXIT

	# Top-level model_provider first (unless already set), then existing
	# content, then the provider table.
	if ! grep -q "^model_provider = " "$CODEX_CONFIG"; then
		printf 'model_provider = "%s"\n\n' "$CODEX_PROVIDER" >"$tmp"
	fi
	cat "$CODEX_CONFIG" >>"$tmp"
	cat >>"$tmp" <<EOF

[model_providers."$CODEX_PROVIDER"]
name = "$CODEX_PROVIDER"
base_url = "https://llm.int.exe.xyz/v1"
requires_openai_auth = false
EOF

	mv "$tmp" "$CODEX_CONFIG"
	trap - EXIT
	echo "configured Codex to use the exe.dev LLM gateway"
else
	echo "Codex exe.dev LLM gateway already configured"
fi
