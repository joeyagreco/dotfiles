#!/usr/bin/env bash
# fires a native macOS notification when claude code needs input.
# receives the notification event as json on stdin.

input=$(cat)

message=$(printf '%s' "$input" | jq -r '.message // "Needs your input"')
project=$(printf '%s' "$input" | jq -r '.cwd // "" | split("/") | last')

osascript -e "display notification \"${message}\" with title \"Claude Code\" subtitle \"${project}\" sound name \"Glass\""
