#!/bin/bash

battery_info=$(pmset -g batt)
percentage=$(echo "$battery_info" | grep -Eo "\d+%" | head -1 | tr -d '%')

if echo "$battery_info" | grep -q "AC Power"; then
	echo " $percentage%"
else
	if [ "$percentage" -ge 80 ]; then
		icon=" "
	elif [ "$percentage" -ge 60 ]; then
		icon=" "
	elif [ "$percentage" -ge 40 ]; then
		icon=" "
	elif [ "$percentage" -ge 20 ]; then
		icon=" "
	else
		icon=" "
	fi
	echo "$icon $percentage%"
fi
