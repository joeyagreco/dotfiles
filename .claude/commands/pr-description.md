---
description: Generate and update PR title and description for the current branch
allowed-tools: Bash(gh pr diff:*), Bash(gh pr edit:*)
---
You are generating and updating a pull request title and description for the current branch.

## Process
1. **Get the PR diff**: `gh pr diff`

2. **Update the PR**: `gh pr edit --title "TITLE" --body "BODY"`

## Title Guidelines
- Use conventional commit format when appropriate (feat:, fix:, docs:, refactor:, etc.)
- Keep it concise but descriptive (max ~72 characters)
- Focus on WHAT the change does, not HOW

## Description Guidelines
Structure the body with:

1. **Summary**: 1-2 sentences explaining the purpose of the changes

2. **Changes**: Bullet points of the key changes made
   - Group related changes together
   - Focus on user-facing or architecturally significant changes

## Rules
- Infer the purpose from the code changes
- Be concise but comprehensive
- Do not include implementation details unless they're architecturally significant
