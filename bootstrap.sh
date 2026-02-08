#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

echo "NOTE: This bootstrap script is deprecated. Prefer chezmoi." >&2
echo "See: MIGRATING_TO_CHEZMOI.md" >&2
echo "" >&2

function doIt() {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude "bootstrap.sh" \
		--exclude "brew.sh" \
		--exclude "setup-dev.sh" \
		--exclude ".macos" \
		--exclude "backup" \
		--exclude "README.md" \
		--exclude "LICENSE-MIT.txt" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read REPLY"?This may overwrite existing files in your home directory. Are you sure (y/n)? ";
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;
