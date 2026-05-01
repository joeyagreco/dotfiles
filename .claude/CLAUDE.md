# CLAUDE.md


## safety / boundaries
- never attempt to deploy, push to production, or run destructive operations without explicit user confirmation
    - when in doubt, present the plan and wait for approval.
- never send messages on slack. reading/searching is fine, but do not send or schedule messages.

## writing style (for comments, PR descriptions, docs, slack messages, etc.)
- be concise - cut the fluff, get to the point
- for links/references, use "(source)" or "see X for more" instead of inline URLs when possible
- avoid em-dashes - use commas or just start a new sentence
- use parenthetical asides naturally like "(if we want it)"
- don't over-explain - trust the reader to follow along
- avoid formal bullet-point-style prose in paragraphs - let it flow naturally

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
- new comments should be in all lower case
    - if existing comments do not follow this rule.. do NOT change them to conform
- new docstrings should use "proper" casing
    - always conform to existing conventions when updating docstrings 
- use existing constants, enums, and mappings defined in the project rather than hardcoding values. always search for existing constants before introducing new literal values.
- when making changes, limit edits strictly to what was requested. do not add extra entries, refactor adjacent code, or expand scope unless the user explicitly asks.
- spell out variable names. no shorthand abbreviations (e.g. use `user` not `u`, `request` not `req`, `customer` not `cust`). applies to local variables, loop vars, factory spec dict keys, and any string references to those keys. for multiples, use `_one`/`_two` suffixes (e.g. `user_one`, not `u0`).

## testing
- prefer a single, simple test unless explicitly asked for multiple
- when multiple test cases share the same assertion shape and only differ in inputs, always write them as a single table test. never write separate test functions for this.
- avoid over-engineering test cases with unnecessary parameterization or dual-format handling
- match the real data format found in the codebase.
- add a docstring with "GIVEN, WHEN, THEN" to each test function (not inline comments)
- use plain tuples in `@pytest.mark.parametrize` instead of `pytest.param(..., id=)` unless the id adds information beyond what's already in the param values
