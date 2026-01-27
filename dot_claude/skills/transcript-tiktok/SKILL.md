---
name: tiktok-transcript
description: Download and format transcripts from TikTok videos using yt-dlp. Use when the user asks to download transcripts/captions from TikTok URLs, get text content from TikTok videos, or extract subtitles from TikTok. Supports automatic duplicate removal, paragraph detection, and optional timestamp inclusion.
---

# TikTok Transcript Downloader

Download clean, formatted transcripts from TikTok videos using yt-dlp.

## Prerequisites

Ensure yt-dlp is installed before using this skill:

```bash
pip install yt-dlp --break-system-packages
```

## Basic Usage

Use `scripts/download_transcript.py` to download transcripts from TikTok URLs.

### Default Behavior (No Timestamps, Paragraph Detection)

```python
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).parent.parent / 'scripts'))
from download_transcript import download_transcript

# Download transcript with default settings
transcript = download_transcript('https://www.tiktok.com/@username/video/1234567890')
print(transcript)
```

Or via command line:

```bash
python scripts/download_transcript.py "https://www.tiktok.com/@username/video/1234567890"
```

### With Timestamps

If the user explicitly requests timestamps:

```python
transcript = download_transcript(url, include_timestamps=True)
```

Or via command line:

```bash
python scripts/download_transcript.py "URL" --timestamps
```

### Disable Paragraph Detection

To output line-by-line without paragraph breaks:

```python
transcript = download_transcript(url, detect_para=False)
```

Or via command line:

```bash
python scripts/download_transcript.py "URL" --no-paragraphs
```

### Save to File

```python
transcript = download_transcript(url, output_file='transcript.txt')
```

Or via command line:

```bash
python scripts/download_transcript.py "URL" transcript.txt
```

## Features

- **Automatic Duplicate Removal**: Removes consecutive duplicate caption lines
- **Paragraph Detection**: Groups captions into paragraphs based on timing gaps (2+ second gaps indicate paragraph breaks)
- **Clean Formatting**: Outputs readable text without timestamps by default
- **Optional Timestamps**: Include timestamps when user requests them (format: [MM:SS])
- **Multiple Language Support**: Prioritizes English but can handle other languages

## Function Reference

### download_transcript(url, output_file=None, include_timestamps=False, detect_para=True)

**Parameters:**
- `url` (str): TikTok video URL
- `output_file` (str, optional): Path to save transcript file
- `include_timestamps` (bool): Include timestamps in output (default: False)
- `detect_para` (bool): Detect and format paragraphs (default: True)

**Returns:** Formatted transcript string

## Error Handling

The script handles common errors:
- Missing yt-dlp installation
- Videos without captions/transcripts
- Invalid URLs
- Network errors

Error messages are returned as strings starting with "Error:"
