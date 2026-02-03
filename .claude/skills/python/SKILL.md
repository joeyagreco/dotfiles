---
name: python
description: Guidelines when creating, reading, updating, or deleting Python code
---

# Python Guidelines

## Instructions

### imports
Imports should ALWAYS be at the top of the file.
NEVER have local imports unless it is 100% necessary.

### formatting
For big numbers, use _ to make numbers more clear
BAD: `foo = 1000`
GOOD: `foo = 1_000`

### __init__.py files
Do not add anything inside of `__init__.py` files unless it is absolutely necessary or you are explicitly asked to.
This includes adding `__all__`; NEVER add that.

### function parameters
Functions with more than 1 parameter should ALWAYS use `*` to enforce keyword arguments.
BAD: `def foo(a, b, c): ...`
GOOD: `def foo(*, a, b, c): ...`
Functions should always use required parameters unless making a parameter optional is absolutely necessary.
Functions should not set defaults for parameters unless it is an EXTREMELY sane default.
