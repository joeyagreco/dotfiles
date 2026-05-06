---
description: Generate and update PR title and description for the current branch
allowed-tools: Bash(gh pr diff:*), Bash(gh pr edit:*)
---
You are generating and updating a pull request title and description for the current branch.

## Process
1. **Get the PR diff**: `gh pr diff`

2. **Update the PR**: `gh pr edit --title "TITLE" --body "BODY"`

## Title Guidelines
- If the branch name or commit messages contain a ticket number (like `JAN-316` or `FOO-123`), prefix the title with it like "[JAN-316] Some Title". Only use ticket numbers that appear as-is, never construct one by combining parts from different sources.
- Otherwise, use conventional commit format (Feat:, Fix:, Docs:, Refactor:, etc.)
- Keep it concise but descriptive (max ~72 characters)
- Focus on WHAT the change does, not HOW

## Description Guidelines
IMPORTANT: NEVER remove embedded media (images, videos, GIFs, etc) from an existing PR description. Other existing content like links can be replaced if your new description covers the same ground.

Sections:

1. **Summary**: 1-2 sentences explaining the purpose of the changes

2. **Changes**: Bullet points explaining things that are not immediately obvious by looking at the code diff
   - Focus on product level changes, not code level changes
   - Refrain from referencing code here

## Rules
- Use proper casing (standard capitalization) for the title and description, not lowercase
- Infer the purpose from the code changes
- Be concise but comprehensive
- Do not include implementation details unless they're architecturally significant
- Do NOT add any attribution footer (e.g., "Generated with Claude Code")
- Only include the sections listed above. Do not add any other sections.
