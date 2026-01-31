#!/bin/bash

# navigate to openscad
osascript -e 'tell application "OpenSCAD" to activate'

# wait for window to come to foreground
sleep 0.5

# take screenshot and copy to clipboard
screencapture -c

# navigate back to alacritty
osascript -e 'tell application "Alacritty" to activate'

echo "screenshot copied to clipboard"
