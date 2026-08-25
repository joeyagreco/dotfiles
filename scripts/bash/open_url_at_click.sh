#! /bin/bash

# ghostty matches urls one row at a time, and tmux redraws each row of a wrapped line on its own, so ghostty can only open the first row of a url that wraps.
# tmux still tracks which rows continue a wrapped line, so capture-pane -J rebuilds the logical line and the url under the mouse comes back whole.

mouse_x=$1
mouse_y=$2
pane=$3

width=$(tmux display-message -p -t "$pane" '#{pane_width}')

export URL_RE="(https?|ftp)://[^[:space:]\"'\`<>]+"

url=$(tmux capture-pane -p -J -t "$pane" | awk -v w="$width" -v mx="$mouse_x" -v my="$mouse_y" '
BEGIN { row = 0 }
{
  length_of_line = length($0)
  rows = (length_of_line == 0) ? 1 : int((length_of_line + w - 1) / w)
  if (my >= row && my < row + rows) {
    offset = (my - row) * w + mx + 1
    rest = $0
    consumed = 0
    match_count = 0
    while (match(rest, ENVIRON["URL_RE"])) {
      start = consumed + RSTART
      end = start + RLENGTH - 1
      text = substr(rest, RSTART, RLENGTH)
      match_count++
      last_match = text
      if (offset >= start && offset <= end) { print text; exit }
      consumed = end
      rest = substr(rest, RSTART + RLENGTH)
    }
    if (match_count == 1) print last_match
    exit
  }
  row += rows
}')

url=$(echo "$url" | sed -E 's/[).,;:!?]+$//')

if [ -n "$url" ]; then
	open "$url"
fi

exit 0
