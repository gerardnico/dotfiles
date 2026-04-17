---
name: transcribe
description: |
    Transcribe / get transcripts / captions / subtitles from a social media URL
    such as TikTok, YouTube, Twitter or audio, video
allowed-tools: Bash,Read,Write
disable-model-invocation: false # to prevent Claude from triggering it automatically.
model: haiku
---

## How to Use

### Step 1: Execute the transcribe cli

Execute the `transcribe` command with:

* the `--agent` flag
* the URL as argument
* and optionally the language in 2 letters format if asked

#### Example without language

**User:** "Can you download the transcript for the
video https://www.tiktok.com/@account/video/7589746658594819358?"

**Agent:** I'll download the transcript for you.

```bash
transcribe --agent https://www.tiktok.com/@account/video/7589746658594819358
```

#### Example with languages

**User:** "Get me the transcripts in French for the video https://x.com/account/status/2012561898097594545"

**Agent:** I'll download the transcripts in French for you.

```bash
transcribe --agent --lang fr https://x.com/account/status/2012561898097594545
```

### Step 2: Handle the command stdout

- The transcript is printed to stdout. Show it to the user
- Tells the user that if he wants he can ask for another language
- If the user asks for another language, repeat to [step 1](#step-1-execute-the-transcribe-cli)
