#!/bin/bash

# get most recently downloaded file
recent_file=$(find ~/Downloads -type f -exec stat -f "%m %N" {} + | sort -n | tail -1 | cut -d' ' -f2-)

# save to env var
export LAST_DOWNLOAD="$recent_file"

# copy path to clipboard
echo "$recent_file" | pbcopy

echo "copied '$recent_file' to clipbard and \$LAST_DOWNLOAD"
