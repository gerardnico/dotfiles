---
name: transcript-downloader
description: |
    Download / get transcripts / captions / subtitles from a social media URL
    such as TikTok, YouTube, Twitter
allowed-tools: Bash,Read,Write
disable-model-invocation: false # to prevent Claude from triggering it automatically.
model: haiku
---

## How to Use

### Step 1: Execute the transcript-downloader cli

Execute the `transcript-downloader` command with:

* the `--agent` flag
* the URL as argument
* and optionally the language in 2 letters format if asked

#### Example without language

**User:** "Can you download the transcript for the
video https://www.tiktok.com/@account/video/7589746658594819358?"

**Agent:** I'll download the transcript for you.

```bash
transcript-downloader --agent https://www.tiktok.com/@account/video/7589746658594819358
```

#### Example with languages

**User:** "Get me the transcripts in French for the video https://x.com/account/status/2012561898097594545"

**Agent:** I'll download the transcripts in French for you.

```bash
transcript-downloader --agent --lang fr https://x.com/account/status/2012561898097594545
```

### Step 2: Handle the command stdout

- The transcript is printed to stdout. Show it to the user
- Tells the user that if he wants he can ask for another language
- If the user asks for another language, repeat to [step 1](#step-1-execute-the-transcript-downloader-cli)
