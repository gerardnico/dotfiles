---
name: transcript-downloader
description: |
    Download / get transcripts / captions / subtitles from a video
    on social media such as TikTok, YouTube, Twitter
allowed-tools: Bash,Read,Write
disable-model-invocation: false # to prevent Claude from triggering it automatically.
model: haiku
---

## How to Use

### Step 1: Execute the transcript-downloader cli

Execute the `transcript-downloader` command with:
* the URL as argument
* and optionally the language if asked

#### Example without language

**User:** "Can you download the transcript for the
video https://www.tiktok.com/@account/video/7589746658594819358?"

**Agent:** I'll download the transcript for you.

```bash
transcript-downloader https://www.tiktok.com/@account/video/7589746658594819358
```

#### Example with languages

**User:** "Get me the transcripts in French for the video https://x.com/account/status/2012561898097594545"

**Agent:** I'll download the transcripts in French for you.

```bash
transcript-downloader --lang fr https://x.com/account/status/2012561898097594545
```

### Step 2: Handle the command stdout

- Get the transcript file from the stdout.
  - The transcript file has the pattern `subtitle.$LANG.txt` where `$LANG` is the language code
  - Example for English United States: `subtitle.eng-US.txt` where the `$LANG` value is `eng-US`
- Output the transcript file content and the language downloaded
- And tells the user that if he wants he can ask for another language
- if the user asks for another language, repeat to [step 1](#step-1-execute-the-transcript-downloader-cli)
