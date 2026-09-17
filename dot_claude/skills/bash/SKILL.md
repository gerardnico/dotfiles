---
name: bash
description: Instructions for the generation of bash script
---

* when writing a command use the long option format instead of the single letter. Example:

```bash
# bad: U is a single letter
useradd -U appuser
# good: --user-group is the equivalent long flag
useradd --user-group appuser
```

* at the top of script, use the below shebang and `set` configuration

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
```

* how to test if a variable exists.

```bash
if [ "${MY_VAR:-}" != '' ]; then
  echo "exist"
else
  echo "does not exist"
fi
```

* use colored output with `echo` for warning and error
