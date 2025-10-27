---
description: Get most recent CI failures in GitHub for the currently checked out git branch 
allowed-tools: Bash(gh pr list:*), Bash(gh pr checks:*), Bash(gh run view:*), Bash(git branch --show-current)
---
You are reviewing CI failures from the GitHub CI for the current branch.

## Process
1. **Get current branch name**: `git branch --show-current`

2. **Get PR for current branch**: `gh pr list --head {BRANCH_NAME} --json number,title,body,files`

3. **Get failing checks**: `gh pr checks {PR_NUMBER} --json event,link,name,state,bucket,workflow`
   - Extract run IDs from `link` field (format: .../runs/{RUN_ID})

4. **Analyze failures iteratively**:
   - Start broad: `gh run view {RUN_ID} --log-failed 2>&1 | grep -A 20 "FAILED\|ERROR" | head -100`
   - Narrow down: Add more specific greps based on what you find (e.g., `grep -E "AssertionError|ValueError"`)
   - Get context: Use `-B 10` (before) or `-A 30` (after) flags to see surrounding lines
   - Always limit output with `head -N` to avoid overwhelming responses

## Output
Provide:
1. **CI Failures**: 
   - Related to PR changes
   - Possibly unrelated/flaky
2. **Root Causes**: What's failing and why
3. **Recommended Actions**: Concrete next steps

Do Not Provide:
1. **PR Context**: What changed (from files/description)

## Strategy
- Make multiple targeted queries rather than one massive dump
- Start broad, then filter progressively based on findings
- If output is empty, broaden your grep patterns
- Use `2>&1` to capture all output streams
