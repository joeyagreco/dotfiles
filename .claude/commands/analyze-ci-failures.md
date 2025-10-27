---
description: Get most recent CI failures in GitHub for the currently checked out git branch 
allowed-tools: Bash(gh pr list:*), Bash(gh pr checks:*), Bash(gh run view:*), Bash(git branch --show-current)
---
You are reviewing CI failures from the GitHub CI for the current branch.

## Process

1. **Get current branch name**
    - Run: `git branch --show-current`

2. **Get PR for current branch**
   - Run: `gh pr list --head {BRANCH_NAME} --json number,title,body,files`
   - Extract the PR number for use in the next step

3. **Get GitHub PR check information**
   - Run: `gh pr checks {PR_NUMBER} --json event,link,name,state,bucket,workflow)`
   - Identify any failing checks (state != "success" or conclusion == "failure")
   - Extract run IDs from the `link` field (format: https://github.com/owner/repo/actions/runs/{RUN_ID})

4. **Get error logs from failing checks**
   - For each failing check, run: `gh run view {RUN_ID} --log-failed`
   - Analyze the error messages and stack traces

## Output

Provide a summary with:

1. **PR Context**: Brief description of what changes this PR introduces (from files and description)

2. **CI Failures Analysis**:
   - **Likely related to PR changes**: Failures that appear connected to the modified files or functionality
   - **Possibly unrelated/flaky**: Failures that seem environmental or intermittent

3. **Root Causes**: For each related failure, explain:
   - What's failing
   - Why it's likely related to the PR changes
   - Relevant error messages

4. **Recommended Actions**: Concrete next steps to fix the issues
