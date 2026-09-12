# KISS-YT-DLP

A fast, lightweight, portable desktop GUI and local API for [yt-dlp](https://github.com/yt-dlp/yt-dlp) and FFmpeg on Windows. Designed with simplicity, portability, and clean zero-bloat UX.

---

## Key Features

- **True Portability**: Runs completely self-contained. All configurations, presets, logs, and downloads are kept within the application directory. No system installation or registry modifications required.
- **7 Built-in Smart Presets**:
  - **Best Quality**: Highest available video and audio streams merged via FFmpeg.
  - **Music — Best Audio**: Downloads audio-only and retains original encoding or embeds tags.
  - **Video Editor — Fast Import**: MP4 remuxing with minimal overhead for quick NLE imports.
  - **Video Editor — Max Compatibility**: Transcodes to standard H.264/AAC MP4.
  - **Quick Access — Fastest**: Prefers single combined streams for rapid access.
  - **Small File**: Caps resolution to 720p for low disk/bandwidth usage.
  - **Custom**: Full user control over resolutions, containers, audio codecs, and subtitles.
- **One-Click & Ctrl+V Auto-Download**: Instant download trigger on paste or single-click without repetitive settings tweaks.
- **Automatic Step-Down Fallback**: If a requested video quality (e.g., 4K or 1440p) isn't available on the remote server, it smoothly steps down to the nearest available resolution tier without failing or interrupting you with dialogs.
- **Local Loopback REST API**: Built-in localhost HTTP API (`127.0.0.1:8765`) enabling headless downloads and browser-extension integrations using the same shared queue and preset system.
- **Built-in Binary Updates**: Automated in-app updater for `yt-dlp` and `ffmpeg` with SHA-256 verification and automatic rollback.

---

## Getting Started

### Using the Release Executable (Recommended)

1. Download the latest `KISS-YT-DLP-v*.zip` from the [Releases](https://github.com/x1rid/KISS-YT-DLP/releases) tab.
2. Extract the folder anywhere (e.g., Desktop or USB drive).
3. Double-click `YTDLP-GUI.exe`.

### Running from Source

#### Prerequisites
- Windows 10 or 11 (64-bit)
- Python 3.11+
- `yt-dlp.exe`, `ffmpeg.exe`, and `ffprobe.exe` placed in `bin/` (or accessible on your system `PATH`)

#### Installation
```powershell
# Clone repository
git clone https://github.com/x1rid/KISS-YT-DLP.git
cd KISS-YT-DLP

# Create and activate virtual environment
python -m venv .venv
.\.venv\Scripts\Activate.ps1

# Install requirements
pip install -r requirements.txt
pip install -r requirements-build.txt

# Launch application
python main.py
```

---

## Building the Portable Executable

To build the standalone single-executable package locally:

```powershell
powershell -ExecutionPolicy Bypass -File .\build.ps1 -Clean
powershell -ExecutionPolicy Bypass -File .\verify_build.ps1
```

The resulting standalone executable will be located in `dist/YTDLP-GUI.exe`.

---

## Running Automated Tests

A comprehensive suite of 75 unit and integration tests is included:

```powershell
.\.venv\Scripts\python.exe -m unittest discover tests -v
```

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
