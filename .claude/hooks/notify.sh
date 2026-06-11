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

# skip if the terminal is already focused (i'm looking at the session).
# if the focus check fails for any reason, default to notifying.
terminal_app="alacritty"
frontmost=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)
if [ "$(printf '%s' "$frontmost" | tr '[:upper:]' '[:lower:]')" = "$terminal_app" ]; then
  exit 0
fi

message=$(printf '%s' "$input" | jq -r '.message // "Needs your input"')
project=$(printf '%s' "$input" | jq -r '.cwd // "" | split("/") | last')

osascript -e "display notification \"${message}\" with title \"Claude Code\" subtitle \"${project}\" sound name \"Glass\""
