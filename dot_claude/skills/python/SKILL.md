---
name: python
description: Rules to write python code
---

* Use `uv` as package manager, not `pip`
* Use a `dataclass` or a `pydantic` class, not a `TypedDict` in order to use dot notation
* When passing argument to a function, pass them by name, not by position
* use `pyproject.toml`
* don't use `print` unless it's a code for a cli that output data on stdout. For logging information, uses a logger from
  logging
