#!/usr/bin/env sh

# set-default-shell.sh
#
# Make fish the default login shell. Adds fish to /etc/shells if
# missing, then chsh to it. No-op if fish isn't installed or is already the
# default shell.

set -eu

FISH_PATH=$(command -v fish || true)

[ -n "$FISH_PATH" ] || {
	echo "fish not found; skipping default shell setup" >&2
	exit 0
}

if ! grep -q "^$FISH_PATH\$" /etc/shells; then
	echo "$FISH_PATH" | sudo tee -a /etc/shells >/dev/null
fi

if [ "${SHELL:-}" != "$FISH_PATH" ]; then
	# On macOS the user authenticates directly; on Linux the account often
	# has no/locked password, so chsh must go through (passwordless) sudo.
	if [ "$(uname)" = "Darwin" ]; then
		chsh -s "$FISH_PATH"
	else
		sudo chsh -s "$FISH_PATH" "$(id -un)"
	fi
fi
