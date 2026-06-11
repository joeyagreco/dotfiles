#!/usr/bin/env bash
# fires a native macOS notification when claude code needs input.
# receives the notification event as json on stdin.

input=$(cat)

# only notify for permission prompts, skip idle ("waiting for your input") and others
notification_type=$(printf '%s' "$input" | jq -r '.notification_type // ""')
case "$notification_type" in
  *permission*) ;;
  *) exit 0 ;;
esac

message=$(printf '%s' "$input" | jq -r '.message // "Needs your input"')
project=$(printf '%s' "$input" | jq -r '.cwd // "" | split("/") | last')

osascript -e "display notification \"${message}\" with title \"Claude Code\" subtitle \"${project}\" sound name \"Glass\""
