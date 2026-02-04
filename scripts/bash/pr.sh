#!/bin/bash

# usage: pr "some pr title"
# creates a github pull request with the given title and opens it in the browser.
# if a pr already exists for the current branch, just opens it.
# if no title is provided, defaults to "WIP"

# exit on error
set -e

# check if a pr already exists for the current branch
if PR_URL=$(gh pr view --json url -q .url 2>/dev/null); then
    echo "pr already exists:"
    echo "$PR_URL"
    echo ""
    echo "opening in browser..."
    open "$PR_URL"
    exit 0
fi

# default to "WIP" if no title provided
TITLE="${1:-WIP}"

# create the pr and capture the url
PR_URL=$(gh pr create --title "$TITLE" --fill --draft)

# print confirmation
echo "✅ pull request created:"
echo "$PR_URL"
echo ""
echo "opening in browser..."

# open in browser
open "$PR_URL"
