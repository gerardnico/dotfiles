---
name: transcript-dl
description: Download/Get video transcripts/captions/subtitle
allowed-tools: Bash,Read,Write
disable-model-invocation: true # to prevent Claude from triggering it automatically.
---

# Instructions

## Check Available Subtitles

Execute:

```bash
yt-dlp --list-subs "YOUTUBE_URL"
```

This shows what subtitle types are available without downloading anything. Look for:

- Manual subtitles (better quality)
- Auto-generated subtitles (usually available)
- Available languages
