# CLAUDE.md


## safety / boundaries
- never attempt to deploy, push to production, or run destructive operations without explicit user confirmation
    - when in doubt, present the plan and wait for approval.

## writing style (for comments, PR descriptions, docs, slack messages, etc.)
- use lowercase for almost everything, including sentence starts
- use common abbreviations when they're obvious (DD for Datadog, etc.)
- keep it casual and conversational - "stuff like", "sadly", "so basically"
- be concise - cut the fluff, get to the point
- for links/references, use "(source)" or "see X for more" instead of inline URLs when possible
- avoid em-dashes - use commas or just start a new sentence
- use parenthetical asides naturally like "(if we want it)"
- don't over-explain - trust the reader to follow along
- avoid formal bullet-point-style prose in paragraphs - let it flow naturally
- no need for perfect grammar or formal structure

## code formatting
- new comments should be in all lower case
    - if existing comments do not follow this rule.. do NOT change them to conform
- use existing constants, enums, and mappings defined in the project rather than hardcoding values. always search for existing constants before introducing new literal values.
- when making changes, limit edits strictly to what was requested. do not add extra entries, refactor adjacent code, or expand scope unless the user explicitly asks.

## testing
- when writing tests, prefer a single, simple test unless explicitly asked for multiple
- avoid over-engineering test cases with unnecessary parameterization or dual-format handling
- match the real data format found in the codebase.
