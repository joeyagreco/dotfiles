---
description: Generate and update PR title and description for the current branch
allowed-tools: Bash(gh pr diff:*), Bash(gh pr view:*), Bash(gh pr edit:*)
---
You are generating and updating a pull request title and description for the current branch.

## Process
1. **Get the PR diff**: `gh pr diff`

2. **Get the existing PR body**: `gh pr view --json body -q .body`
   - Scan it for embedded media (lines with `<img>`, `![...](...)`, `<video>`, or `user-attachments` / `githubusercontent` URLs) and carry every one into the new body verbatim.

3. **Update the PR**: `gh pr edit --title "TITLE" --body "BODY"`

## Title Guidelines
- If the branch name or commit messages contain a ticket number (like `JAN-316` or `FOO-123`), prefix the title with it like "[JAN-316] Some Title". Only use ticket numbers that appear as-is, never construct one by combining parts from different sources.
- Otherwise, use conventional commit format (Feat:, Fix:, Docs:, Refactor:, etc.)
- Never prefix with (Feat:, Fix:, Docs:, Refactor:, etc.) if we already have a ticket number
    - GOOD: "[FOO-123] Some Title"
    - GOOD: "Fix: Some Title"
    - BAD: "[FOO-123] Feat: Some Title"
- Keep it concise but descriptive (max ~72 characters)
- Focus on WHAT the change does, not HOW

## Description Guidelines
IMPORTANT: NEVER remove embedded media (images, videos, GIFs, etc) from an existing PR description. Other existing content like links can be replaced if your new description covers the same ground.

Sections:

1. **Summary**: 1-2 sentences explaining the purpose of the changes

## Rules
- References to fields should use backticks (`` ` ``) in both the title and the description
- Use proper casing (standard capitalization) for the title and description, not lowercase
- Infer the purpose from the code changes
- Be concise 
- Do not include implementation details unless they're architecturally significant
- Do NOT add any attribution footer (e.g., "Generated with Claude Code")
- Only include the sections listed above. Do not add any other sections.
