---
name: transcript-downloader
description: Download/Get transcripts/captions/subtitle from a video
allowed-tools: Bash,Read,Write
disable-model-invocation: false # to prevent Claude from triggering it automatically.
model: haiku
---

## How to Use

### Step 1: Determine the video URL and the Language

If not specified, ask the user which languages they want.
Common language codes include:

- `en` - English
- `es` - Spanish
- `nl` - Dutch
- `fr` - French
- `de` - German
- `it` - Italian
- `pt` - Portuguese
- `ja` - Japanese
- `zh` - Chinese
- `ko` - Korean
- `ar` - Arabic

Confirm the language code with the user if it's ambiguous

### Step 2: Run the Script

Execute the `transcript-downloader` command with the language and URL.

```bash
usage: transcript-downloader [-h] [--output OUTPUT] [--langs LANGS] url

Get video transcript

positional arguments:
  url                   Video URL

options:
  -h, --help            show this help message and exit
  --output OUTPUT, -o OUTPUT
                        Output file path
  --langs LANGS, -l LANGS
                        The languages codes separated by a comma
```

Example Usage:

**User:** "Can you download the English transcript for the
video https://www.tiktok.com/@account/video/7589746658594819358?"

**Claude:**

```bash
transcript-downloader --lang en https://www.tiktok.com/@account/video/7589746658594819358
```

**User:** "Get me transcripts in Spanish and French for the video https://x.com/account/status/2012561898097594545"

**Claude:** I'll download transcripts in both languages for you.

```bash
transcript-downloader --lang es,fr https://x.com/account/status/2012561898097594545
```

### Step 3: Handle the Output

- Check if the script executed successfully
- Inform the user of the results
- If there are any downloaded files, let the user know where they can be found
