#!/usr/bin/env sh

# brew-bundle-split.sh
#
# Dump the currently installed Homebrew state and partition it into two files:
#
#   Brewfile        portable taps + formulae (installed on macOS AND Linux)
#   Brewfile.macos  macOS only formulae, casks, mas
#
# `brew bundle dump` only produces a single combined file, so this script
# routes each line to the correct file. Formulae are portable EXCEPT the ones
# listed in MACOS_ONLY_FORMULAE below, which have no Linux build.

set -eu

CONFIG_DIR="$1" # config/homebrew directory

BREWFILE="$CONFIG_DIR/Brewfile"
BREWFILE_MACOS="$CONFIG_DIR/Brewfile.macos"

# Formulae that exist in homebrew-core but only build on macOS.
MACOS_ONLY_FORMULAE="mas trash"

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

# Dump everything except language package managers (managed by mise) to a temp file.
# Descriptions are included by default now, so --describe is not passed.
brew bundle dump --no-go --no-cargo --no-npm --force --file "$tmp"

# Start both output files fresh.
: >"$BREWFILE"
: >"$BREWFILE_MACOS"

# Route each entry, carrying its preceding "# description" comment along.
pending_comment=""

is_macos_only_formula() {
	name=$1
	for f in $MACOS_ONLY_FORMULAE; do
		[ "$name" = "$f" ] && return 0
	done
	return 1
}

# Extract the quoted argument from a brew/cask/tap line, e.g. brew "git" -> git.
quoted_arg() {
	printf '%s' "$1" | sed -n 's/^[a-z]* "\([^"]*\)".*/\1/p'
}

while IFS= read -r line; do
	case "$line" in
	\#*)
		# Buffer a description comment until we see the entry it belongs to.
		pending_comment=$line
		continue
		;;
	tap\ *)
		dest=$BREWFILE
		;;
	brew\ *)
		name=$(quoted_arg "$line")
		# Strip any tap prefix (e.g. umputun/apps/revdiff -> revdiff).
		base=${name##*/}
		if is_macos_only_formula "$base"; then
			dest=$BREWFILE_MACOS
		else
			dest=$BREWFILE
		fi
		;;
	cask\ * | mas\ *)
		dest=$BREWFILE_MACOS
		;;
	"")
		# Drop blank lines and any orphaned comment.
		pending_comment=""
		continue
		;;
	*)
		dest=$BREWFILE
		;;
	esac

	[ -n "$pending_comment" ] && printf '%s\n' "$pending_comment" >>"$dest"
	printf '%s\n' "$line" >>"$dest"
	pending_comment=""
done <"$tmp"
