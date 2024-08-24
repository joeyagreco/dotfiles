battery_info=$(pmset -g batt)
percentage=$(echo "$battery_info" | grep -Eo "\d+%" | head -1)

if echo "$battery_info" | grep -q "AC Power"; then
	echo " $percentage"
else
	echo "$percentage"
fi
