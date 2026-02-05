#!/usr/bin/env python3
"""
PDF Compression Script using Ghostscript

This script compresses all PDF files in a directory using Ghostscript.
Compressed files are saved with a '-compressed' suffix.
"""

import os
import subprocess
import argparse
from pathlib import Path


def compress_pdf(input_path, output_path):
  """
  Compress a PDF file using Ghostscript.

  Args:
      input_path: Path to the input PDF file
      output_path: Path to the output compressed PDF file

  Returns:
      True if successful, False otherwise
  """
  gs_command = [
    'gs',
    '-sDEVICE=pdfwrite',
    '-dCompatibilityLevel=1.4',
    '-dPDFSETTINGS=/ebook',
    '-dNOPAUSE',
    '-dQUIET',
    '-dBATCH',
    f'-sOutputFile={output_path}',
    input_path
  ]

  try:
    subprocess.run(gs_command, check=True, capture_output=True)
    return True
  except subprocess.CalledProcessError as e:
    print(f"Error compressing {input_path}: {e}")
    return False
  except FileNotFoundError:
    print("Error: Ghostscript (gs) is not installed or not in PATH")
    return False


def process_directory(directory, recursive=False):
  """
  Process all PDF files in a directory.

  Args:
      directory: Path to the directory containing PDF files
      recursive: Whether to process subdirectories recursively
  """
  directory = Path(directory)

  if not directory.exists():
    print(f"Error: Directory '{directory}' does not exist")
    return

  if not directory.is_dir():
    print(f"Error: '{directory}' is not a directory")
    return

  # Find all PDF files
  if recursive:
    pdf_files = list(directory.rglob('*.pdf'))
  else:
    pdf_files = list(directory.glob('*.pdf'))

  # Filter out already processed files (those ending in -original)
  pdf_files = [f for f in pdf_files if not f.stem.endswith('-original')]

  if not pdf_files:
    print(f"No PDF files found in '{directory}'")
    return

  print(f"Found {len(pdf_files)} PDF file(s) to compress")

  success_count = 0
  fail_count = 0

  for pdf_file in pdf_files:
    # Create temporary output filename
    temp_output = pdf_file.parent / f"{pdf_file.stem}-temp-compressed{pdf_file.suffix}"

    print(f"Processing: {pdf_file.name}")

    if compress_pdf(str(pdf_file), str(temp_output)):
      # Get file sizes
      original_size = pdf_file.stat().st_size
      compressed_size = temp_output.stat().st_size
      reduction = (1 - compressed_size / original_size) * 100

      # Rename original file to add -original suffix
      original_backup = pdf_file.parent / f"{pdf_file.stem}-original{pdf_file.suffix}"
      pdf_file.rename(original_backup)

      # Rename compressed file to original name
      temp_output.rename(pdf_file)

      print(f"  ✓ Compressed: {original_size:,} bytes → {compressed_size:,} bytes "
            f"({reduction:.1f}% reduction)")
      print(f"    Original saved as: {original_backup.name}")
      success_count += 1
    else:
      fail_count += 1
      print(f"  ✗ Failed to compress")
      # Clean up temp file if it exists
      if temp_output.exists():
        temp_output.unlink()

  print(f"\nSummary: {success_count} successful, {fail_count} failed")


def main():
  parser = argparse.ArgumentParser(
    description='Compress PDF files in a directory using Ghostscript',
    formatter_class=argparse.RawDescriptionHelpFormatter,
    epilog="""
Examples:
  %(prog)s /path/to/pdfs
  %(prog)s /path/to/pdfs --recursive
  %(prog)s . -r
        """
  )

  parser.add_argument(
    'directory',
    help='Directory containing PDF files to compress'
  )

  parser.add_argument(
    '-r', '--recursive',
    action='store_true',
    help='Process subdirectories recursively'
  )

  args = parser.parse_args()

  process_directory(args.directory, args.recursive)


if __name__ == '__main__':
  main()
