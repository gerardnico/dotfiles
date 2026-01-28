#!/usr/bin/env python3
"""
TikTok Transcript Downloader using yt-dlp
Downloads and formats transcripts from TikTok videos
"""
import argparse
import sys
from dataclasses import dataclass
from pathlib import Path

YT_DLP_VERSION = "2025.12.8"

try:
  import yt_dlp
except ImportError:
  print("Error: yt-dlp is not installed. Install it with: pip install yt-dlp", file=sys.stderr)
  sys.exit(1)

try:
  import webvtt
except ImportError:
  print("Warning: webvtt-py not installed. Install with: pip install webvtt-py")


def _require_dependency(pkg: str, version: str):
  """To verify dependency"""
  from importlib.metadata import version as v
  from packaging.version import Version

  installed = Version(v(pkg))
  required = Version(version)

  if installed != required:
    raise RuntimeError(
      f"[Dependency error] {pkg}=={required} required, "
      f"but {installed} is installed"
    )


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


# Custom parser to print the help (not the small usage)
class ArgumentParserNoUsage(argparse.ArgumentParser):
  def error(self, message):
    # Print the error message and the help (not the usage)
    # https://docs.python.org/3.11/library/argparse.html#printing-help
    print(f'\nerror: {message}', self.format_help(), sep='\n\n', file=sys.stderr)
    sys.exit(2)


from urllib.parse import urlparse, parse_qs


def post_processing_vtt(vtt_file_path: Path) -> None:
  """
  Process a single VTT file using the webvtt library.

  Args:
      vtt_file_path: Path to the VTT file
  """
  try:
    # Parse the VTT file
    vtt = webvtt.read(str(vtt_file_path))

    # Extract all text from captions
    text_lines = []
    for caption in vtt:
      # Get the text and strip whitespace
      text = caption.text.strip()
      if text:
        text_lines.append(text)

    # Create output filename with .txt extension
    output_file = vtt_file_path.with_suffix('.txt')

    # Write the cleaned text to file
    with open(output_file, 'w', encoding='utf-8') as f:
      f.write('\n'.join(text_lines))

    print(f"Processed: {vtt_file_path.name} -> {output_file.name}")

  except Exception as e:
    print(f"Error processing {vtt_file_path.name}: {e}")


def post_processing(directory: str) -> None:
  """
  Search for all .vtt files in a directory using the webvtt library,
  extract clean text, and save as .txt files.

  Args:
      directory: Path to the directory containing VTT files
  """

  directory_path = Path(directory)

  if not directory_path.exists():
    raise ValueError(f"Directory does not exist: {directory}")

  processed_count = 0
  for item in directory_path.iterdir():
    # Check if it's a file and has .vtt extension
    if item.is_file() and item.suffix.lower() == '.vtt':
      post_processing_vtt(item)
      processed_count += 1

  if processed_count == 0:
    print(f"No .vtt files found in {directory}")
  else:
    print(f"Processed {processed_count} VTT file(s)")


@dataclass
class ServiceInfo:
  apex_name: str
  service_name: str
  id: str


# If you want to use dot notation (like result.id), you need to use a dataclass or regular class
# because with TypedDict, you need to access the values using dictionary bracket notation, not dot notation
def extract_url_components(url) -> ServiceInfo:
  parsed = urlparse(url)
  apex_name = parsed.netloc

  # remove www. if present
  if apex_name.startswith("www."):
    apex_name = apex_name[4:]

  # service name is the first part before the dot
  service_name = apex_name.split('.')[0]

  # default id is empty
  id_value = ""

  # YouTube URL handling
  if "youtube.com" in apex_name:
    # YouTube video ID is usually in the 'v' query parameter
    query_params = parse_qs(parsed.query)
    id_value = query_params.get('v', [''])[0]

  # TikTok URL handling
  elif "tiktok.com" in apex_name:
    # TikTok ID is made of username (without @) + last part of path
    path_parts = [p for p in parsed.path.split('/') if p]
    if len(path_parts) >= 3 and path_parts[0].startswith('@') and path_parts[1] == 'video':
      username = path_parts[0][1:]  # remove @
      video_id = path_parts[2]
      id_value = f"{username}-{video_id}"

  return ServiceInfo(
    apex_name=apex_name,
    service_name=service_name,
    id=id_value
  )


def main():
  _require_dependency("yt-dlp", YT_DLP_VERSION)

  parser = ArgumentParserNoUsage(description='Get video transcript')
  parser.add_argument('url', help='Video URL')
  parser.add_argument('--output', '-o',
                      help='Output file path')
  args = parser.parse_args()
  url = args.url

  # Determine the output directory
  # Note that if we want to add a timestamp, we
  # * need to get the info.json first
  # or, we can add `%(upload_date>%Y-%m-%d)s` in a template
  download_directory = args.output
  if download_directory is None:
    url_components = extract_url_components(url)
    download_directory = f"out/{url_components.service_name}/{url_components.id}"

  # We use the main cli
  # because it's also possible to embed it, but it's a pain in the ass
  # the options are not the same as the doc and the download happens as an option
  # For embedding, see https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#embedding-yt-dlp
  #
  # To get video info, it's:
  # with yt_dlp.YoutubeDL(ydl_opts) as ydl:
  #    info = ydl.extract_info(url, download=False)

  # transcript = download_transcript(url, output_file, include_timestamps, detect_para)
  args = [
    # Do not download the video but write all related files (Alias: --no-download)
    "--skip-download",
    # Download the subtitle (not generated)
    "--write-subs",
    # Write automatically generated subtitle file (Alias: --write-automatic-subs)
    "--write-auto-subs",
    # Subtitle format; accepts formats preference separated by "/", e.g. "srt" or "ass/srt/best"
    "--sub-format", "ass/srt/best",
    # Lang selections: Languages of the subtitles to download (can be regex) or "all" separated by commas, e.g.
    # --sub-langs "en.*,ja" (where "en.*" is a regex pattern that matches "en" followed by 0 or more of any character).
    # You can prefix the language code with a "-" to exclude it from the requested languages, e.g.
    # --sub-langs all,-live_chat. Use --list-subs for a list of available language tags
    "--sub-langs", "en.*",
    # indicate a template for the output file names
    # https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#output-template
    # "-o", "subtitle:%(extractor)s-%(uploader)s-%(id)s.%(ext)s",
    "-o", f"subtitle:subtitle.%(ext)s",
    # Write video metadata to a .info.json file
    "--write-info-json",
    "-o" f"infojson:infojson",
    # Location in the filesystem where yt-dlp can store some downloaded information (such as
    # client ids and signatures) permanently. By default, ${XDG_CACHE_HOME}/yt-dlp
    # --cache-dir DIR
    # Write thumbnail image to disk (extension is image when unknown - mostly webp)
    # originCover
    "--write-thumbnail",
    # not .%(ext)s as it's added by yt_dlp as image
    "-o" f"thumbnail:thumbnail",
    # Convert the thumbnails to another format (currently supported: jpg, png, webp)
    "--convert-thumbnails", "webp",
    # Number of seconds to sleep before each subtitle download
    "--sleep-subtitles", "1",
    # The paths where the files should be downloaded.
    # Specify the type of file and the path separated by a colon ":". All the same
    # TYPES as --output are supported. Additionally, you can also provide "home" (default) and "temp" paths.
    # All intermediary files are first downloaded to the temp path and then the final files are moved over to
    # the home path after download is finished.
    # This option is ignored if --output is an absolute path
    # Specify the working directory (home)
    "--paths", f"home:{download_directory}",
    # put all temporary files in "wd\tmp"
    "--paths", "temp:tmp",
    # put all subtitle files in home/working directory
    "--paths", "subtitle:.",
    url
  ]
  try:
    yt_dlp.main(args)
  except SystemExit as e:
    # We do post-processing, so we catch the system exit
    if e.code != 0:
      raise  # Re-raise to actually exit

  # Vtt file processing
  post_processing(download_directory)


if __name__ == '__main__':
  main()
