#!/bin/sh
# statusline for claude code - model and context usage only

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# context progress bar (10 blocks wide)
if [ -n "$used" ]; then
	filled=$(echo "$used" | awk '{printf "%d", ($1 / 10 + 0.5)}')
	empty=$((10 - filled))
	bar=""
	i=0
	while [ $i -lt $filled ]; do
		bar="${bar}█"
		i=$((i + 1))
	done
	i=0
	while [ $i -lt $empty ]; do
		bar="${bar}░"
		i=$((i + 1))
	done
	# green up to 25%, yellow above 25% through 70%, red above 70%
	color=$(echo "$used" | awk '{ if ($1 <= 25) print "32"; else if ($1 <= 70) print "33"; else print "31" }')
	ctx_bar="  [${bar}] ${used}%"
else
	color="90"
	ctx_bar="  [░░░░░░░░░░] …"
fi

printf '\033[90m%s\033[0m' "$model"
[ -n "$ctx_bar" ] && printf '\033[%sm%s\033[0m' "$color" "$ctx_bar"
printf '\n'
