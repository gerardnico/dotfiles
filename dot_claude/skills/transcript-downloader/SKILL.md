---
name: transcript-downloader
description: Download/Get transcripts/captions/subtitle from a video
allowed-tools: Bash,Read,Write
disable-model-invocation: true # to prevent Claude from triggering it automatically.
model: haiku
---

## How to Use

### Step 1: Determine the Language

Ask the user which languages they want for the transcript if not already specified. Common language codes include:

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

### Step 2: Run the Script

Execute the transcript download script with the specified language:

```bash
python [YOUR_SKILL_PATH]/scripts/transcript-downloader.py --lang [LANGUAGES_CODE]
```

Replace `[YOUR_SKILL_PATH]` with the actual path to where this skill is located (e.g., `user/transcript-downloader` or
`examples/transcript-downloader`).

Replace `[LANGUAGES_CODE]` with a string of the two-letter languages determined in `step 1` separated by a comma.

### Step 3: Handle the Output

- Check if the script executed successfully
- Inform the user of the results
- If there are any downloaded files, let the user know where they can be found

## Example Usage

**User:** "Can you download the English transcript?"

**Claude:**

```bash
python .claude/skills/transcript-downloader/scripts/transcript-downloader.py --lang en
```

**User:** "Get me transcripts in Spanish and French"

**Claude:** I'll download transcripts in both languages for you.

```bash
python /mnt/skills/user/transcript-downloader/scripts/transcript-downloader.py --lang es,fr
```

## Notes

- Always confirm the language code with the user if it's ambiguous
- Check the script's output for any errors or warnings
