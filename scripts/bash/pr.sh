#!/bin/bash

# usage: pr "some pr title"
# creates a github pull request with the given title, copies the pr url to clipboard, and prints it.
# if no title is provided, defaults to "WIP"

# exit on error
set -e

# default to "WIP" if no title provided
TITLE="${1:-WIP}"

# create the pr and capture the url
# gh pr create outputs the url on the last line
PR_URL=$(gh pr create --title "$TITLE" --fill --draft)

# print confirmation
echo "✅ pull request created:"
echo "$PR_URL"
echo ""
echo "opening in browser..."

# open in browser
open "$PR_URL"
