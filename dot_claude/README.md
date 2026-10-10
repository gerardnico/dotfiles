# Claude

## Settings

* [settings.json](settings.json) - system setting
* [settings.local.json](settings.local.json) - settings linked into each project

### Settings.json

* disable attribution commit and pr to disable
  the [system-reminder](https://code.claude.com/docs/en/agent-sdk/modifying-system-prompts)

## Api Key Helper

Deprecated as it works with

```bash
# key
export ANTHROPIC_AUTH_TOKEN=xxx
# empty
export ANTHROPIC_API_KEY=""
```

For an example, see [Claude Api Key Helper](../bin-local/executable_claude-api-key-helper)

```json
{
    "apiKeyHelper": "claude-api-key-helper"
}
```
