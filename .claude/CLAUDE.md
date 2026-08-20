# CLAUDE.md

## CRITICAL
ALWAYS use ASD-STE100 Simplified Technical English when you talk to me. See @.claude/skills/asd-ste100/SKILL.md

## safety / boundaries
- never attempt to deploy, push to production, or run destructive operations without explicit user confirmation
    - when in doubt, present the plan and wait for approval.
- never send messages on slack. reading/searching is fine, but do not send or schedule messages.
- never edit or create on notion without explicit permission.
- never commit or push code

## writing style (for comments, PR descriptions, docs, slack messages, etc.)
- be concise - cut the fluff, get to the point
- for links/references, use "(source)" or "see X for more" instead of inline URLs when possible
- use parenthetical asides naturally like "(if we want it)"
- don't over-explain - trust the reader to follow along
- avoid formal bullet-point-style prose in paragraphs - let it flow naturally
- NEVER use em dashes
- NEVER use phrasing like "it's not X, it's Y"

## python
- use `*` to enforce keyword-only arguments when a function has 2+ parameters (e.g. `def foo(*, name, age)`). not needed for single-param functions.
- avoid default values in function signatures
- for one-off scripts, use `uv` with PEP 723 inline script metadata so they can be run with `uv run script.py`. define dependencies in a comment block at the top:
    ```python
    # /// script
    # requires-python = ">=3.12"
    # dependencies = ["requests", "rich"]
    # ///
    ```

## code formatting
- new comments must keep each sentence entirely on one line
    - never wrap a sentence across lines, no matter how long the line gets
    - this overrides line-length limits, formatter defaults, and surrounding wrap style
    - multi-line comment blocks are fine as long as every line is a whole sentence
    - never end a comment with a semicolon (;)
EXAMPLES:
# this is an example of a
# bad comment because it spans
# the same sentence across multiple lines

# this is an example of a good comment because it spans a sentence within a single line

- new docstrings should use "proper" casing
    - always conform to existing conventions when updating docstrings 
- use existing constants, enums, and mappings defined in the project rather than hardcoding values. always search for existing constants before introducing new literal values.
- when making changes, limit edits strictly to what was requested. do not add extra entries, refactor adjacent code, or expand scope unless the user explicitly asks.
- spell out variable names. no shorthand abbreviations (e.g. use `user` not `u`, `request` not `req`, `customer` not `cust`). applies to local variables, loop vars, factory spec dict keys, and any string references to those keys. for multiples, use `_one`/`_two` suffixes (e.g. `user_one`, not `u0`).
- NEVER add comments inline unless explicitly asked

## testing
- prefer a single, simple test unless explicitly asked for multiple
- when multiple test cases share the same assertion shape and only differ in inputs, always write them as a single table test. never write separate test functions for this.
- avoid over-engineering test cases with unnecessary parameterization or dual-format handling
- match the real data format found in the codebase.
- add a docstring with "GIVEN, WHEN, THEN" to each test function (not inline comments)
- use plain tuples in `@pytest.mark.parametrize` instead of `pytest.param(..., id=)` unless the id adds information beyond what's already in the param values

## responses
- NEVER end with a clickbaity "One more thing", "One thing to note", "One question" sentence. You do not need to clickbait me into continuing the conversation.
- NEVER use these phrases:
    - "one thing worth flagging"
    - "it's not X, its Y" (or any version of that)
- ALWAYS send links explicitly, do not try to format them as markdown
