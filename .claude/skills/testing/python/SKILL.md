# Python Testing Skill

## Test Naming and Documentation

When writing tests, use descriptive test names that clearly convey what is being tested. Never use docstrings in unit tests.

**Good examples:**
```python
def test_user_registration_with_valid_email():
    # test implementation

def test_divide_by_zero_raises_value_error():
    # test implementation

def test_empty_list_returns_none():
    # test implementation
```

**Bad example:**
```python
def test_complex_algorithm_performance():
    """
    tests that the algorithm completes within 100ms for inputs up to 10,000 items.
    this is a regression test for issue #123 where performance degraded significantly.
    """
    # test implementation
```
