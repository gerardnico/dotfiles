#!/usr/bin/env python3
"""
TikTok Transcript Downloader using yt-dlp
Downloads and formats transcripts from TikTok videos
"""

import sys
import json
import re
from pathlib import Path

try:
    import yt_dlp
except ImportError:
    print("Error: yt-dlp is not installed. Install it with: pip install yt-dlp --break-system-packages", file=sys.stderr)
    sys.exit(1)


def clean_duplicate_lines(lines):
    """Remove consecutive duplicate lines"""
    if not lines:
        return []

    cleaned = [lines[0]]
    for line in lines[1:]:
        if line.strip() and line.strip() != cleaned[-1].strip():
            cleaned.append(line)
    return cleaned


def detect_paragraphs(lines, time_gap_threshold=2.0):
    """
    Detect paragraph breaks based on timing gaps
    Returns list of paragraphs (each paragraph is a list of lines)
    """
    if not lines:
        return []

    paragraphs = []
    current_paragraph = []

    for i, line in enumerate(lines):
        current_paragraph.append(line['text'])

        # Check if there's a significant time gap to next line
        if i < len(lines) - 1:
            time_gap = lines[i + 1]['start'] - line['end']
            if time_gap > time_gap_threshold:
                # End current paragraph
                paragraphs.append(current_paragraph)
                current_paragraph = []

    # Add the last paragraph
    if current_paragraph:
        paragraphs.append(current_paragraph)

    return paragraphs


def format_transcript(subtitles, include_timestamps=False, detect_para=True):
    """
    Format transcript with optional timestamps and paragraph detection
    """
    if not subtitles:
        return "No transcript available"

    # Parse subtitle data
    lines = []
    for item in subtitles:
        if 'text' in item and item['text'].strip():
            lines.append({
                'text': item['text'].strip(),
                'start': item.get('start', 0),
                'end': item.get('end', 0)
            })

    if not lines:
        return "No transcript content found"

    # Remove duplicates first
    unique_lines = []
    seen = set()
    for line in lines:
        text = line['text'].lower()
        if text not in seen:
            seen.add(text)
            unique_lines.append(line)

    if include_timestamps:
        # Format with timestamps
        result = []
        for line in unique_lines:
            timestamp = format_timestamp(line['start'])
            result.append(f"[{timestamp}] {line['text']}")
        return '\n'.join(result)
    else:
        # Format without timestamps
        if detect_para:
            # Detect paragraphs based on timing
            paragraphs = detect_paragraphs(unique_lines)
            # Join lines within paragraphs with space, separate paragraphs with double newline
            formatted_paragraphs = [' '.join(para) for para in paragraphs]
            return '\n\n'.join(formatted_paragraphs)
        else:
            # Simple line-by-line format
            return '\n'.join([line['text'] for line in unique_lines])


def format_timestamp(seconds):
    """Convert seconds to MM:SS format"""
    minutes = int(seconds // 60)
    secs = int(seconds % 60)
    return f"{minutes:02d}:{secs:02d}"


def download_transcript(url, output_file=None, include_timestamps=False, detect_para=True):
    """
    Download transcript from TikTok URL

    Args:
        url: TikTok video URL
        output_file: Optional path to save transcript
        include_timestamps: Whether to include timestamps in output
        detect_para: Whether to detect paragraph breaks

    Returns:
        Formatted transcript string
    """
    ydl_opts = {
        'skip_download': True,
        'writesubtitles': True,
        'writeautomaticsub': True,
        'subtitleslangs': ['en'],
        'quiet': True,
        'no_warnings': True,
    }

    try:
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(url, download=False)

            # Try to get subtitles
            subtitles = None
            if 'subtitles' in info and info['subtitles']:
                # Try English first
                if 'en' in info['subtitles']:
                    subtitles = info['subtitles']['en'][0]['data']

            # Fall back to automatic captions
            if not subtitles and 'automatic_captions' in info and info['automatic_captions']:
                if 'en' in info['automatic_captions']:
                    subtitles = info['automatic_captions']['en'][0]['data']

            if not subtitles:
                return "Error: No transcript/captions available for this video"

            # Format the transcript
            formatted = format_transcript(subtitles, include_timestamps, detect_para)

            # Save to file if specified
            if output_file:
                Path(output_file).write_text(formatted, encoding='utf-8')
                print(f"Transcript saved to: {output_file}")

            return formatted

    except Exception as e:
        return f"Error downloading transcript: {str(e)}"


def main():
    """CLI interface"""
    if len(sys.argv) < 2:
        print("Usage: python download_transcript.py <tiktok_url> [output_file] [--timestamps] [--no-paragraphs]")
        print("\nOptions:")
        print("  --timestamps      Include timestamps in output")
        print("  --no-paragraphs   Disable paragraph detection")
        sys.exit(1)

    url = sys.argv[1]
    output_file = None
    include_timestamps = '--timestamps' in sys.argv
    detect_para = '--no-paragraphs' not in sys.argv

    # Check for output file argument (not starting with --)
    for arg in sys.argv[2:]:
        if not arg.startswith('--'):
            output_file = arg
            break

    transcript = download_transcript(url, output_file, include_timestamps, detect_para)

    if not output_file:
        print(transcript)


if __name__ == '__main__':
    main()
