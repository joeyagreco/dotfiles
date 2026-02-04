---
name: rerun-stuck-actions
description: Identify and restart stuck GitHub Actions jobs on the current branch
arguments:
  - name: threshold
    description: Minutes a job must be running to be considered stuck (default 20)
    required: false
allowed-tools: Bash
allowed-bash-prompts:
  - git branch
  - gh run list
  - gh run view
  - gh run cancel
  - gh run rerun
  - sleep
---

# Rerun Stuck GitHub Actions

This command identifies GitHub Actions jobs that appear to be stuck and restarts them.

## Step 1: Get Current Branch Info

Run these commands to get context:

```bash
# get current branch
git branch --show-current

# get the latest workflow run for this branch
gh run list --branch $(git branch --show-current) --limit 1 --json databaseId,status,conclusion,name
```

## Step 2: Identify Stuck Jobs

A job is considered "stuck" if:
- The workflow run is still "in_progress"
- The job has been running for longer than the threshold (default: 20 minutes)
- The job shows no recent log activity

Use this command to get detailed job info:

```bash
gh run view <RUN_ID> --json jobs --jq '.jobs[] | select(.status == "in_progress") | {name: .name, id: .databaseId, startedAt: .startedAt, status: .status}'
```

Calculate how long each in-progress job has been running. Jobs running longer than the threshold are considered stuck.

## Step 3: Report Findings

Before taking action, report to the user:
- Which workflow run was checked
- How many jobs are in progress
- Which jobs appear stuck (running > threshold minutes)
- Recommendation for action

## Step 4: Cancel and Rerun

If stuck jobs are found:

1. Cancel the workflow run:
```bash
gh run cancel <RUN_ID>
```

2. Wait a few seconds for cancellation to process:
```bash
sleep 5
```

3. Rerun failed/cancelled jobs:
```bash
gh run rerun <RUN_ID> --failed
```

4. Verify the rerun started:
```bash
gh run view <RUN_ID> --json status,jobs --jq '{status: .status, inProgress: [.jobs[] | select(.status == "in_progress") | .name]}'
```

## Step 5: Provide Summary

Report:
- What was cancelled
- What was restarted
- Link to the workflow run for monitoring

## Notes

- If no workflow runs are found for the current branch, inform the user
- If no jobs appear stuck, inform the user that everything looks healthy
- The threshold argument can be used to adjust sensitivity (e.g., `/rerun-stuck-actions 15` for 15 minutes)
- Default threshold is 20 minutes if not specified
