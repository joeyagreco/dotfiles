#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <repo_name>"
	exit 1
fi

REPO_NAME=$1

function f_nuke_repo() {
	NUKE_PATH="$LOCAL_GIT_REPO_PATH/$REPO_NAME"
	echo "nuking $NUKE_PATH ..."

	if [ -d "$NUKE_PATH" ]; then
		rm -rf "$NUKE_PATH"
		if [ -d "$NUKE_PATH" ]; then
			echo "Failed to remove $NUKE_PATH"
			exit 1
		fi
	fi

	CLONE_COMMAND="git@github.com:$GITHUB_PREFIX/$REPO_NAME.git"
	echo "cloning from $CLONE_COMMAND ..."
	git clone "$CLONE_COMMAND" "$NUKE_PATH"
	if [ $? -ne 0 ]; then
		echo "git clone failed"
		exit 1
	fi
}

f_nuke_repo
