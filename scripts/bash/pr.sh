#!/bin/bash

# usage: pr "some pr title"
# creates a github pull request with the given title, copies the pr url to clipboard, and prints it.

# exit on error
set -e

# ensure a title was provided
if [ -z "$1" ]; then
	echo "❌ error: no pr title provided."
	echo "usage: pr \"some pr title\""
	exit 1
fi

# create the pr and capture the url
# gh pr create outputs the url on the last line
PR_URL=$(gh pr create --title "$1" --fill)

# print confirmation
echo "✅ pull request created:"
echo "$PR_URL"
echo ""
echo "enter to open in browser"

# read user input
read -n 1 -s key

# check if enter was pressed (empty key) or any key other than q
if [ -z "$key" ] || [ "$key" != "q" ]; then
	if [ -z "$key" ]; then
		open "$PR_URL"
		echo "opening in browser..."
	fi
fi
