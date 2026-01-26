---
description: Generate and update PR title and description for the current branch
allowed-tools: Bash(gh pr diff:*), Bash(gh pr edit:*)
---
You are generating and updating a pull request title and description for the current branch.

## Process
1. **Get the PR diff**: `gh pr diff`

2. **Update the PR**: `gh pr edit --title "TITLE" --body "BODY"`

## Title Guidelines
- If you have an issue or ticket number, prefix the title of the PR with it like so "[FOO-123] Some Title"
- Otherwise, use conventional commit format (feat:, fix:, docs:, refactor:, etc.)
- Keep it concise but descriptive (max ~72 characters)
- Focus on WHAT the change does, not HOW

## Description Guidelines
IMPORTANT: If there is already useful information in the description (like links, images, etc), use it when generating your new description.

Structure the body with:

1. **Summary**: 1-2 sentences explaining the purpose of the changes

2. **Changes**: Bullet points of the key changes made
   - Group related changes together
   - Focus on user-facing or architecturally significant changes

## Rules
- Infer the purpose from the code changes
- Be concise but comprehensive
- Do not include implementation details unless they're architecturally significant
- Do NOT add any attribution footer (e.g., "Generated with Claude Code")
