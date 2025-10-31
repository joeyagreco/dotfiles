#!/bin/bash

# first, set up custom keymaps
hidutil property --set "$(cat $HOME/.config/macos/key_remaps.json)" >/dev/null 2>&1

# to get an idea of what to change for a particular setting
# defaults read > before.txt
# { MAKE CHANGE IN SETTINGS }
# defaults read > after.txt
# diff before.txt after.txt

# https://macos-defaults.com/
# https://gist.github.com/brandonb927/3195465/
# https://emmer.dev/blog/automate-your-macos-defaults/
# https://gist.github.com/sickcodes/912973b2153b0738ff97621cde4c2bb5

########
# DOCK #
########

# orient dock to the left of the screen
defaults write com.apple.dock "orientation" -string "left"
# autohide dock
defaults write com.apple.dock autohide -bool "true"
# set dock autohide animation time
defaults write com.apple.dock "autohide-time-modifier" -float "0.3"
# set dock icon size
defaults write com.apple.dock "tilesize" -int "48"
# don't show recent apps in dock
defaults write com.apple.dock "show-recents" -bool "false"
# set animation effect for maximizing and minimizing windows
defaults write com.apple.dock "mineffect" -string "scale"

##########
# FINDER #
##########

# show file extensions
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
# show hidden files
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
# use list view
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
# empty bin after 30 days
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"
# don't warn when changing file extension
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
# hide all icons on desktop
defaults write com.apple.finder "CreateDesktop" -bool "false"
# show path bar
defaults write com.apple.finder "ShowPathbar" -bool "true"

#########
# MOUSE #
#########

# set mouse speed
defaults write NSGlobalDomain com.apple.mouse.scaling -float "0.875"
# flip scroll direction (disable natural scrolling)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool "false"

############
# KEYBOARD #
############

# set key repeat rate
defaults write -g InitialKeyRepeat -int "30"
defaults write -g KeyRepeat -int "2"
defaults write -g KeyRepeatDelay -float "0.5"
defaults write -g KeyRepeatEnabled -bool "true"
defaults write -g KeyRepeatInterval -float "0.083333333"
# disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool "false"

#########
# SOUND #
#########

# increase sound quality for Bluetooth headphones/headsets
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int "40"

############
# MENU BAR #
############

# make sure bluetooth is showing in both control center and menu bar
defaults -currentHost write com.apple.controlcenter Bluetooth -int 18
# show battery percentage
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool "true"

################
# STARTUP APPS #
################

# SEE ALL STARTUP ITEMS: osascript -e 'tell application "System Events" to get the name of every login item'

# set apps to start on startup
apps=(
	"Docker:/Applications/Docker.app"
	"Chrome:/Applications/Google Chrome.app"
	"Alacritty:/Applications/Alacritty.app"
	"Hammerspoon:/Applications/Hammerspoon.app"
)

for app in "${apps[@]}"; do
	name="${app%%:*}"
	path="${app#*:}"
	osascript -e "tell application \"System Events\" to make login item at end with properties {name:\"$name\", path:\"$path\", hidden:false}" >/dev/null
done

####################
# SPOTLIGHT SEARCH #
####################

# NOTE: @joeyagreco - sadly i think in newer OS you have to actually set these in Settings under Spotlight

# to see current set, run: 'defaults read com.apple.spotlight orderedItems'
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1; "name" = "APPLICATIONS";}' \
	'{"enabled" = 1; "name" = "CALCULATOR";}' \
	'{"enabled" = 1; "name" = "CONTACT";}' \
	'{"enabled" = 1; "name" = "CONVERSION";}' \
	'{"enabled" = 1; "name" = "DEFINITION";}' \
	'{"enabled" = 1; "name" = "DOCUMENTS";}' \
	'{"enabled" = 1; "name" = "EVENT_TODO";}' \
	'{"enabled" = 1; "name" = "DIRECTORIES";}' \
	'{"enabled" = 1; "name" = "FONTS";}' \
	'{"enabled" = 1; "name" = "IMAGES";}' \
	'{"enabled" = 1; "name" = "OTHER";}' \
	'{"enabled" = 1; "name" = "PDF";}' \
	'{"enabled" = 1; "name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 0; "name" = "MESSAGES";}' \
	'{"enabled" = 0; "name" = "MOVIES";}' \
	'{"enabled" = 0; "name" = "MUSIC";}' \
	'{"enabled" = 0; "name" = "PRESENTATIONS";}' \
	'{"enabled" = 0; "name" = "SIRI_SUGGESTIONS";}' \
	'{"enabled" = 0; "name" = "SPREADSHEETS";}' \
	'{"enabled" = 0; "name" = "TIPS";}' \
	'{"enabled" = 0; "name" = "WEBSEARCH";}'

###########
# GENERAL #
###########

# set to dark theme
osascript -e 'tell app "System Events" to tell appearance preferences to set dark mode to true'

# save screenshots to downloads folder
defaults write com.apple.screencapture location ~/Downloads

# disable automatically arranging spaces based on most recent use
# specifically, this seems to take the short fade animation away when switching windows
# NOTE: this does not seem to work, manually switch OFF "Desktop and Dock" -> "Desktop and Stage Manger" -> "Stage Manager"
defaults write com.apple.dock workspaces-auto-swoosh -bool NO

# needed to have hammerspoon config in a non-default place
# source: https://github.com/Hammerspoon/hammerspoon/issues/1734
# NOTE: you will need to restart hammerspoon for this to work
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"

#################
# RESTART STUFF #
#################

killall Dock
killall Finder
killall SystemUIServer

# erase and rebuild index for spotlight search 'mdutil' for more info
mdutil -E
