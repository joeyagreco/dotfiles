#!/bin/bash

# usage: ./watch-github-pr-ci-status.sh [pr_number]

CHECK_INTERVAL=20

if [ -z "$1" ]; then
	# get current branch
	BRANCH=$(git branch --show-current)
	if [ -z "$BRANCH" ]; then
		echo "error: not on a git branch"
		exit 1
	fi

	echo "no pr number provided, checking current branch: $BRANCH"

	# get pr number for current branch
	PR_NUMBER=$(gh pr list --head "$BRANCH" --json number --jq '.[0].number')

	if [ -z "$PR_NUMBER" ]; then
		echo "error: no pr found for branch $BRANCH"
		exit 1
	fi

	echo "found pr #$PR_NUMBER"
	echo ""
else
	PR_NUMBER=$1
fi

while true; do
	# get check status
	CHECKS=$(gh pr checks "$PR_NUMBER" --json state,name 2>/dev/null)

	if [ $? -ne 0 ]; then
		echo "error: failed to fetch pr checks. ensure pr #$PR_NUMBER exists."
		exit 1
	fi

	# count check states
	TOTAL=$(echo "$CHECKS" | jq length)
	PENDING=$(echo "$CHECKS" | jq '[.[] | select(.state == "PENDING" or .state == "IN_PROGRESS")] | length')
	SUCCESS=$(echo "$CHECKS" | jq '[.[] | select(.state == "SUCCESS")] | length')
	FAILURE=$(echo "$CHECKS" | jq '[.[] | select(.state == "FAILURE")] | length')
	SKIPPED=$(echo "$CHECKS" | jq '[.[] | select(.state == "SKIPPED")] | length')

	# display current status
	clear
	echo "watching pr #$PR_NUMBER checks..."
	echo ""
	echo "total checks: $TOTAL"
	echo "success: $SUCCESS"
	echo "failure: $FAILURE"
	echo "pending/in progress: $PENDING"
	echo "skipped: $SKIPPED"
	echo ""

	# check if all done
	if [ "$PENDING" -eq 0 ]; then
		echo ""
		echo "=========================================="
		if [ "$FAILURE" -eq 0 ]; then
			echo "✓ all checks passed!"
			echo "=========================================="
			# terminal bell
			printf '\a'
			# persistent alert dialog with option to open pr
			BUTTON=$(osascript -e "display dialog \"✓ All checks passed!\" with title \"PR #$PR_NUMBER CI Complete\" buttons {\"OK\", \"Open PR\"} default button \"Open PR\"" 2>/dev/null | grep -o "button returned:[^,]*" | cut -d: -f2)
			# workaround for cursor disappearing after applescript dialog
			osascript -e 'tell application "System Events" to key code 126 using {shift down}' 2>/dev/null
			if [ "$BUTTON" = "Open PR" ]; then
				gh pr view "$PR_NUMBER" --web
			fi
			exit 0
		else
			echo "✗ some checks failed"
			echo "=========================================="
			# terminal bell
			printf '\a'
			# persistent alert dialog with option to open pr
			BUTTON=$(osascript -e "display dialog \"✗ Some checks failed\" with title \"PR #$PR_NUMBER CI Complete\" buttons {\"OK\", \"Open PR\"} default button \"Open PR\"" 2>/dev/null | grep -o "button returned:[^,]*" | cut -d: -f2)
			# workaround for cursor disappearing after applescript dialog
			osascript -e 'tell application "System Events" to key code 126 using {shift down}' 2>/dev/null
			if [ "$BUTTON" = "Open PR" ]; then
				gh pr view "$PR_NUMBER" --web
			fi
			exit 1
		fi
	fi

	echo ""

	# live countdown
	for ((i = CHECK_INTERVAL; i > 0; i--)); do
		printf "\rchecking again in %ds... (ctrl+c to stop)  " "$i"
		sleep 1
	done
	printf "\r                                                \r"
done
