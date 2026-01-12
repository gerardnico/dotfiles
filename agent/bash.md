Instructions for the generation of bash script

* use as shebang

```
#!/usr/bin/env bash
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
