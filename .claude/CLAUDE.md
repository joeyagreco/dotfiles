# CLAUDE.md

## terminal/shell
- cd is aliased to zoxide
    - `cd=z`

## code formatting
- comments should be in all lower case
```
EXAMPLE:
// This is Not Good 
// this is good
```

- makefiles should follow this format for commands:

```makefile
.PHONY: foo 
foo:
	@echo 'foo'

.PHONY: bar 
bar:
	@echo 'bar'
```

## testing

### golang
- always format as table tests
