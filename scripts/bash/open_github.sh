#! /bin/bash

cd "$(tmux run 'echo #{pane_start_path}')" || exit
url=$(git remote get-url origin)

# convert ssh url to https url
url=$(echo "$url" | sed 's/git@github.com:/https:\/\/github.com\//' | sed 's/\.git$//')

open "$url" || echo "no remote found"
