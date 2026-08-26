#! /bin/bash

# ghostty matches urls one row at a time, and tmux redraws each row of a wrapped line on its own, so ghostty can only open the first row of a url that wraps.
# tmux still tracks which rows continue a wrapped line, so capture-pane -J rebuilds the logical line and the url under the mouse comes back whole.
# capture-pane -N prints one line for each visual row, so the clicked row is always at index mouse_y and the script never measures line widths.
# the script reads the word under the mouse on that one row, then opens the rebuilt url that contains the word.

mouse_x=$1
mouse_y=$2
pane=$3

url_regex='(https?|ftp)://[^[:space:]"'"'"'`<>]+'

visual_rows=$(tmux capture-pane -p -N -t "$pane" 2>/dev/null)
logical_lines=$(tmux capture-pane -p -J -N -t "$pane" 2>/dev/null)

clicked_row=$(printf '%s\n' "$visual_rows" | sed -n "$((mouse_y + 1))p")

if [ "$mouse_x" -gt 0 ]; then
    left_part=$(printf '%s' "$clicked_row" | cut -c "1-$mouse_x")
else
    left_part=""
fi
right_part=$(printf '%s' "$clicked_row" | cut -c "$((mouse_x + 1))-")

left_word=$(printf '%s' "$left_part" | sed -E 's/.*[[:space:]]//')
right_word=$(printf '%s' "$right_part" | sed -E 's/[[:space:]].*//')
word="$left_word$right_word"

if [ "${#word}" -lt 3 ]; then
    exit 0
fi

# a row that continues a wrapped url always starts at column 0, so a word without a scheme must start there.
case "$word" in
    *://*) ;;
    *)
        if [ "$left_part" != "$left_word" ]; then
            exit 0
        fi
        ;;
esac

url=""
while IFS= read -r candidate; do
    case "$candidate" in
        *"$word"*)
            url="$candidate"
            break
            ;;
    esac
done <<EOF
$(printf '%s\n' "$logical_lines" | grep -oE "$url_regex")
EOF

url=$(printf '%s' "$url" | sed -E 's/[).,;:!?]+$//')

if [ -n "$url" ]; then
    open "$url"
fi

exit 0
