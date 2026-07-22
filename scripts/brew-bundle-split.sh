#!/usr/bin/env sh

# brew-bundle-split.sh
#
# Dump the currently installed Homebrew state and partition it into two files:
#
#   Brewfile        portable taps + formulae (installed on macOS AND Linux)
#   Brewfile.macos  macOS-only formulae, casks, mas, vscode extensions
#
# `brew bundle dump` only produces a single combined file, so this script
# routes each line to the correct file. Formulae are portable EXCEPT the ones
# listed in MACOS_ONLY_FORMULAE below, which have no Linux build.

set -eu

CONFIG_DIR="$1"        # config/homebrew directory
CURSOR_EXTENSIONS="$2" # path to Cursor extensions.json

BREWFILE="$CONFIG_DIR/Brewfile"
BREWFILE_MACOS="$CONFIG_DIR/Brewfile.macos"

# Formulae that exist in homebrew-core but only build on macOS.
MACOS_ONLY_FORMULAE="mas trash"

# Taps that should live in the macOS file (not referenced by portable formulae).
MACOS_ONLY_TAPS="mike182uk/tap"

tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

# Dump everything (minus vscode; we append those from Cursor below) to a temp.
# Descriptions are included by default now, so --describe is not passed.
brew bundle dump --no-vscode --force --file "$tmp"

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

is_macos_only_tap() {
	name=$1
	for t in $MACOS_ONLY_TAPS; do
		[ "$name" = "$t" ] && return 0
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
		name=$(quoted_arg "$line")
		if is_macos_only_tap "$name"; then
			dest=$BREWFILE_MACOS
		else
			dest=$BREWFILE
		fi
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

# Append vscode extensions from Cursor to the macOS file.
if [ -f "$CURSOR_EXTENSIONS" ]; then
	jq -r '.[].identifier.id' "$CURSOR_EXTENSIONS" | sort -u | while IFS= read -r id; do
		printf 'vscode "%s"\n' "$id" >>"$BREWFILE_MACOS"
	done
fi
