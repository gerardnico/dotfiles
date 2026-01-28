# Script to download a Transcript from a social video

## How to use / Requirement

* Activate the venv if needed

```bash
python -m venv .venv
source .venv/bin/activate
```

* Install the requirement

```bash
pip install -r requirements.txt
# for impersonation: https://github.com/yt-dlp/yt-dlp#impersonation
python -m pip install "yt-dlp[default,curl-cffi]"
```

* Run

```bash
python get-transcript.py https://www.tiktok.com/@xxx/video/xxx
```
