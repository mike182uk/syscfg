#!/usr/bin/env sh

SOURCE="$1"
TARGET="$2"

# Check if the target is a symbolic link
if [ -L "$TARGET" ]; then
	CURRENT_TARGET=$(readlink -f "$TARGET" || true)

	# If the symbolic link doesn't point to the source, update it
	if [ "$CURRENT_TARGET" != "$SOURCE" ]; then
		echo "$TARGET already exists and points to: $CURRENT_TARGET, updating target to: $SOURCE"

		if ! ln -sf "$SOURCE" "$TARGET"; then
			echo "Failed to update symbolic link $TARGET" >&2
			exit 1
		fi
	fi

	exit 0
fi

# If the target exists and is not a symbolic link, back it up
if [ -e "$TARGET" ]; then
	BACKUP="${TARGET}.backup.$(date +%s)"
	echo "$TARGET already exists, backing up to: $BACKUP"

	if ! mv "$TARGET" "$BACKUP"; then
		echo "Failed to move $TARGET to $BACKUP" >&2
	exit 1
	fi
fi

# Create a symbolic link from the target to the source
if ! ln -s "$SOURCE" "$TARGET"; then
	echo "Failed to create symbolic link from $SOURCE to $TARGET" >&2
	exit 1
fi
