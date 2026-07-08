#!/bin/bash

# checks installed versions of key tools against the latest github releases.

set -u

GREEN=$'\033[0;32m'
YELLOW=$'\033[0;33m'
RED=$'\033[0;31m'
RESET=$'\033[0m'

latest_release() {
	local repo="$1"
	local tag
	tag=$(curl -fsSL "https://api.github.com/repos/${repo}/releases/latest" 2>/dev/null | jq -r '.tag_name')
	# some projects (e.g. ghostty) publish git tags but no proper github release
	if [ -z "$tag" ] || [ "$tag" = "null" ]; then
		tag=$(curl -fsSL "https://api.github.com/repos/${repo}/tags" 2>/dev/null | jq -r '.[0].name')
	fi
	printf '%s\n' "$tag" | sed 's/^v//'
}

check() {
	local name="$1"
	local repo="$2"
	local current="$3"

	local latest
	latest=$(latest_release "$repo")

	if [ -z "$latest" ] || [ "$latest" = "null" ]; then
		printf "%-12s %s\n" "$name" "${RED}failed to fetch latest${RESET}"
		return
	fi

	if [ -z "$current" ]; then
		printf "%-12s ${RED}not installed${RESET}  (latest: %s)\n" "$name" "$latest"
		return
	fi

	if [ "$current" = "$latest" ]; then
		printf "%-12s ${GREEN}%-8s${RESET}  (up to date)\n" "$name" "$current"
	else
		printf "%-12s ${YELLOW}%s${RESET} -> ${GREEN}%s${RESET}\n" "$name" "$current" "$latest"
	fi
}

ghostty_version() {
	[ -d /Applications/Ghostty.app ] || return
	defaults read /Applications/Ghostty.app/Contents/Info.plist CFBundleShortVersionString
}

nvim_version() {
	command -v nvim >/dev/null || return
	nvim --version | head -1 | awk '{print $2}' | sed 's/^v//'
}

tmux_version() {
	command -v tmux >/dev/null || return
	tmux -V | awk '{print $2}'
}

starship_version() {
	command -v starship >/dev/null || return
	starship --version | head -1 | awk '{print $2}'
}

hammerspoon_version() {
	[ -d /Applications/Hammerspoon.app ] || return
	defaults read /Applications/Hammerspoon.app/Contents/Info.plist CFBundleShortVersionString
}

check "ghostty" "ghostty-org/ghostty" "$(ghostty_version)"
check "hammerspoon" "Hammerspoon/hammerspoon" "$(hammerspoon_version)"
check "neovim" "neovim/neovim" "$(nvim_version)"
check "starship" "starship/starship" "$(starship_version)"
check "tmux" "tmux/tmux" "$(tmux_version)"
