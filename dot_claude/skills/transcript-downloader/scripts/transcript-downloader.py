#!/usr/bin/env python3
"""
TikTok Transcript Downloader using yt-dlp
Downloads and formats transcripts from TikTok videos
"""
import argparse
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Optional, List

from git.objects.submodule.root import URLCHANGE
from pydantic.v1 import UrlUserInfoError

# May be process the requirement file?
YT_DLP_VERSION = "2025.12.8"
WEB_VTT_VERSION = "0.5.1"

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
class UrlInfo:
  apex_name: str
  service_name: str
  id: str
  url: str


@dataclass
class ModeInfo:
  type: str
  file_name: Optional[str] = None
  file_extension: Optional[str] = None
  video_path: Optional[str] = None
  # The resulting audio file path
  audio_path: Optional[str] = None


@dataclass
class Context:
  video: UrlInfo
  langs: List[str]
  download_directory: str
  mode: ModeInfo


# If you want to use dot notation (like result.id), you need to use a dataclass or regular class
# because with TypedDict, you need to access the values using dictionary bracket notation, not dot notation
def get_url_info(url) -> UrlInfo:
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
    if len(path_parts) != 3 or (not path_parts[0].startswith('@')) or path_parts[1] != 'video':
      raise ValueError("The tiktok url is not valid")
    username = path_parts[0][1:]  # remove @
    video_id = path_parts[2]
    id_value = f"{username}-{video_id}"
  elif "x.com" in apex_name:
    # https://x.com/forrestpknight/status/2012561898097594545
    path_parts = [p for p in parsed.path.split('/') if p]
    if len(path_parts) != 3 and path_parts[1] != 'status':
      raise ValueError("The x url is not valid")
    username = path_parts[0]
    video_id = path_parts[2]
    id_value = f"{username}-{video_id}"

  return UrlInfo(
    apex_name=apex_name,
    service_name=service_name,
    id=id_value,
    url=url
  )


def main_transcript_file(context: Context):
  # Split by comma and loop
  langs_regexp = []
  case_insensitivity_flag = "(?i)"
  lang_separator = ','
  found_orig = False
  orig = "orig"
  for lang in context.langs:
    if lang == orig:
      found_orig = True
      langs_regexp.append(f"{case_insensitivity_flag}.*-{orig}.*")
    else:
      langs_regexp.append(f"{case_insensitivity_flag}{lang}.*")
  langs_ytd = lang_separator.join(langs_regexp)

  # Don't download the orig subtitle if not specified
  if found_orig == False and context.video.service_name == "youtube":
    langs_ytd = f"{langs_ytd}{lang_separator}-.*-{orig}.*"

  # YouTube block by video once you are blocked, it can take time,
  # but it will work with another video
  sleep = len(langs_regexp) * 2

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
    "--sub-format", "vtt/srt/best",
    # Lang selections: Languages of the subtitles to download (can be regex) or "all" separated by commas, e.g.
    # --sub-langs "en.*,ja" (where "en.*" is a regex pattern that matches "en" followed by 0 or more of any character).
    # You can prefix the language code with a "-" to exclude it from the requested languages, e.g.
    # --sub-langs all,-live_chat. Use --list-subs for a list of available language tags
    "--sub-langs", f"{langs_ytd}",
    # indicate a template for the output file names
    # https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#output-template
    # "-o", "subtitle:%(extractor)s-%(uploader)s-%(id)s.%(ext)s",
    "-o", f"subtitle:subtitle.%(ext)s",
    # Write video metadata to a .info.json file
    "--write-info-json",
    "-o", f"infojson:infojson",
    # Location in the filesystem where yt-dlp can store some downloaded information (such as
    # client ids and signatures) permanently. By default, ${XDG_CACHE_HOME}/yt-dlp
    # --cache-dir DIR
    # Write thumbnail image to disk (extension is image when unknown - mostly webp)
    # originCover
    "--write-thumbnail",
    # not .%(ext)s as it's added by yt_dlp as image
    "-o", f"thumbnail:thumbnail",
    # Convert the thumbnails to another format (currently supported: jpg, png, webp)
    "--convert-thumbnails", "webp",
    # Number of seconds to sleep before each subtitle download
    "--sleep-subtitles", f"{sleep}",
    # The paths where the files should be downloaded.
    # Specify the type of file and the path separated by a colon ":". All the same
    # TYPES as --output are supported. Additionally, you can also provide "home" (default) and "temp" paths.
    # All intermediary files are first downloaded to the temp path and then the final files are moved over to
    # the home path after download is finished.
    # This option is ignored if --output is an absolute path
    # Specify the working directory (home)
    "--paths", f"home:{context.download_directory}",
    # put all temporary files in "wd\tmp"
    "--paths", "temp:tmp",
    # put all subtitle files in home/working directory
    "--paths", "subtitle:.",
    context.video.url
  ]
  try:
    yt_dlp.main(args)
  except SystemExit as e:
    # We do post-processing, so we catch the system exit
    if e.code != 0:
      raise  # Re-raise to actually exit

  # Vtt file processing
  post_processing(context.download_directory)


def main_download_video_or_audio(context):
  if Path(context.mode.video_path).exists():
    print(f"File {context.mode.video_path} already downloaded")
    return
  # Download
  args = [
    # https://github.com/yt-dlp/yt-dlp?tab=readme-ov-file#preset-aliases
    "-t", context.mode.file_extension,
    # indicate a template for the output file names
    # https://github.com/yt-dlp/yt-dlp#output-template
    "-o", context.mode.file_name,
    # Write video metadata to a .info.json file
    "--write-info-json",
    "-o", f"infojson:infojson",
    # The directory
    "--paths", f"home:{context.download_directory}",
    context.video.url
  ]
  try:
    yt_dlp.main(args)
  except SystemExit as e:
    # We do post-processing, so we catch the system exit
    if e.code != 0:
      raise  # Re-raise to actually exit


def main_video_to_audio(context):
  if context.mode.type == 'audio':
    raise ValueError("Audio processing not yet implemented")

  if Path(context.mode.audio_path).exists():
    print(f"Audio file already exist: {context.mode.audio_path}")
    return

  command = [
    "ffmpeg",
    "-i", f"{context.mode.video_path}",
    "-ar", "16000",
    "-ac", "1",
    "-af", "loudnorm=I=-16:TP=-1.5:LRA=11",
    "-c:a", "pcm_s16le",
    context.mode.audio_path
  ]

  try:
    result = subprocess.run(
      command,
      check=True,
      capture_output=True,
      text=True
    )
    print("Video to audio transformation was successful")
    print(result.stdout)
  except subprocess.CalledProcessError as e:
    print(f"Error occurred: {e}")
    print(f"Error output: {e.stderr}")


def main_audio_to_text(context):
  output_file_path_without_extension = f"{context.download_directory}/speech"
  output_format_extension = "txt"
  output_format_whisper_argument = "--output-txt"
  output_file_path = f"{output_file_path_without_extension}.{output_format_extension}"
  if Path(output_file_path).exists():
    print(f"Speech file exists: {output_file_path}")
    return

  # https://github.com/ggml-org/whisper.cpp/tree/master/examples/cli
  # --print-colors

  whisper_model_name = "base"
  lang = context.langs[0]
  if lang == "en":
    # The .en models (tiny.en, base.en, small.en, medium.en) are English-only and will always translate to English
    whisper_model_name = "base.en"

  # Get the brew prefix for whisper-cpp
  brew_prefix = subprocess.check_output(
    ["brew", "--prefix", "whisper-cpp"],
    text=True
  ).strip()

  whisper_model = f"{brew_prefix}/models/ggml-{whisper_model_name}.bin"
  command = [
    "whisper-cli",
    "--model", whisper_model,
    "--no-timestamps",  # no timestamp left to the text
    # "--print-colors",  # confidence  - highlight words with high or low confidence:
    "--processors", "4",  # number of processors to use during computation
    "--language", lang,  # language
    "--output-file", output_file_path_without_extension,  # without the extension
    output_format_whisper_argument,
    "-f", context.mode.audio_path
  ]

  try:
    subprocess.run(command)
    print("Audio Speech to text transformation was successful")
  except subprocess.CalledProcessError as e:
    print(f"Error occurred: {e}")
    print(f"Error output: {e.stderr}")


def main():
  _require_dependency("yt-dlp", YT_DLP_VERSION)
  _require_dependency("webvtt-py", WEB_VTT_VERSION)

  parser = ArgumentParserNoUsage(description='Get video transcript')
  parser.add_argument('url', help='Video URL')
  parser.add_argument('--output', '-o',
                      help='Output file path')
  parser.add_argument('--langs', '-l',
                      help='The languages codes separated by a comma. Example for Spanish and French: es,fr'
                      )
  parser.add_argument('--mode', '-m',
                      default='text',
                      choices=['text', 'audio', 'video'],
                      help='The mode of transcript: text (download the text subtitle file) or video (download, speech to text)'
                      )
  args = parser.parse_args()
  url = args.url

  url_info = get_url_info(url)

  # Determine the output directory
  # Note that if we want to add a timestamp, we
  # * need to get the info.json first
  # or, we can add `%(upload_date>%Y-%m-%d)s` in a template
  download_directory = args.output
  if download_directory is None:
    download_directory = f"out/{url_info.service_name}/{url_info.id}"

  # orig is a lang suffix of YouTube
  # it the video is in nl, you get 2 subtitles, `nl` and `nl-orig`
  orig = "orig"
  if args.langs is None:
    # lang_input = input("Please specify a lang (example: en): ")
    # print(f"You selected: {lang_input}")
    if url_info.service_name == "youtube":
      langs = [orig]
    else:
      langs = ["en"]
  else:
    langs = args.langs.split(",")

  context = Context(
    video=url_info,
    langs=langs,
    download_directory=download_directory,
    mode=ModeInfo(type=args.mode)
  )
  mode = args.mode
  if mode == 'text':
    main_transcript_file(context)
  else:
    if context.mode.type == 'video':
      context.mode.file_extension = "mp4"
      context.mode.file_name = f"{context.mode.type}.{context.mode.file_extension}"
      context.mode.video_path = f"{context.download_directory}/{context.mode.file_name}"
      context.mode.audio_path = f"{context.download_directory}/audio.wav"
      main_download_video_or_audio(context)
      main_video_to_audio(context)
      main_audio_to_text(context)
    else:
      context.mode.file_extension = "mp3"
      context.mode.file_name = f"{context.mode.type}.{context.mode.file_extension}"
      context.mode.audio_path = f"{context.download_directory}/{context.mode.file_name}"
      raise ValueError(f"{context.mode.type} not yet implemented")


if __name__ == '__main__':
  main()
