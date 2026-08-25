#!/usr/bin/env bash
# repeats the asd-ste100 response rules on every prompt.
# claude.md loads one time per session, so a long session can lose the rule.
# the rules live in one place, the marked block in claude.md, and this hook reads them back out.

cat >/dev/null # drain the event json on stdin, this hook does not need it

claude_md="$HOME/.claude/CLAUDE.md"
[ -f "$claude_md" ] || exit 0

rules=$(sed -n '/ste100:start/,/ste100:end/p' "$claude_md" | sed '1d;$d')
[ -n "$rules" ] || exit 0

printf '%s\n' "$rules" | jq -Rs '{hookSpecificOutput:{hookEventName:"UserPromptSubmit",additionalContext:.}}'
