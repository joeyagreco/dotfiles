---
name: python
description: Guidelines when creating, reading, updating, or deleting Python code
---

# Makefile Formatting

## Instructions

### imports
Imports should always be at the top of the file.
NEVER have local imports unless it is 100% necessary.

### formatting
For big numbers, use _ to make numbers more clear
BAD: `foo = 1000`
GOOD: `foo = 1_000`
