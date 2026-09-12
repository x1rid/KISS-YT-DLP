# PROJECT_CONTEXT.md — YTDLP-GUI

> **Critical Context for AI Agents & Developers:**  
> This file contains the complete specification, architectural blueprint, operational rules, and development roadmap for **YTDLP-GUI**. Any AI agent resuming this conversation or starting a new session on this repository must read and adhere strictly to the guidelines defined in this document.

---

## 1. Project Overview & Identity

- **Application Name**: `YTDLP-GUI`
- **Application Type**: Standalone Windows desktop GUI application
- **Technology Stack**:
  - **Language**: Python (CPython 3.11+ / 3.14+)
  - **UI Framework**: PyQt6 (Native desktop widgets, responsive dark Windows 11 styling)
  - **Download Engine**: `yt-dlp` (invoked via safe subprocess with argument lists)
  - **Media Processing**: `FFmpeg` and `FFprobe` (for stream merging, extraction, and post-processing)
- **Core Philosophy**: **KISS** (*Keep It Simple, Stupid*). The application is a practical utility for downloading media, not an unnecessarily complex media-management platform.
- **Portability Mandate**:
  - The entire application must be **100% portable**.
  - All configurations, caches, history, logs, and managed binaries are stored self-contained (e.g. `<App_Directory>/data/` and `<App_Directory>/bin/`) so the entire folder or standalone executable can run from any drive, USB stick, or path without leaving traces in Windows registry or requiring global system installations.
- **Strict Isolation from Parcel**:
  - This project is **100% separate** from the user's *Parcel* project.
  - **NEVER** import Parcel modules, reuse Parcel branding, reuse Parcel UI, add Parcel features, or place YTDLP-GUI inside Parcel's architecture.

---

## 2. Core User Experience

- **Standard Workflow**:
  1. Paste media URL.
  2. Click **Download**.
  3. Automatically downloads the highest practical quality (`bestvideo*+bestaudio/best`) and merges video/audio via FFmpeg.
  4. Displays live progress (percentage, speed, ETA, status).
  5. User can cancel, retry, or remove downloads.
- **Advanced Options**: Hidden by default behind an "Advanced" toggle button. Exposed only when explicitly requested.

---

## 3. Dependency & Binary Resolution Order

The application must **not** assume `yt-dlp` or `FFmpeg` are installed globally in the system PATH. It must support project-local binaries or managed runtimes.

### `yt-dlp` Search Order
1. Configured custom path (from user settings)
2. Project directory root (`yt-dlp.exe`)
3. Project `bin/` directory (`bin/yt-dlp.exe`)
4. Portable data bin directory (`data/bin/yt-dlp.exe`)
5. System PATH (`shutil.which("yt-dlp")`)
6. Fallback user runtime directory (`%LOCALAPPDATA%\YTDLP-GUI\bin\yt-dlp.exe`)

### `FFmpeg` & `FFprobe` Search Order
1. Configured custom path (from user settings)
2. Project directory root (`ffmpeg.exe`, `ffprobe.exe`)
3. Project `bin/` directory (`bin/ffmpeg.exe`, `bin/ffprobe.exe`)
4. Portable data bin directory (`data/bin/ffmpeg.exe`, `data/bin/ffprobe.exe`)
5. System PATH (`shutil.which("ffmpeg")`, `shutil.which("ffprobe")`)
6. Fallback user runtime directory (`%LOCALAPPDATA%\YTDLP-GUI\bin\`)

If any required executable is missing, the application must **never** fail silently or pretend it is available; it must display a clear, actionable error banner in the GUI. Portable self-containment inside `bin/` or `data/bin/` is always preferred.

---

## 4. Architectural Layout

```
YTDLP-GUI/
├── main.py                     # Entry point & Qt application bootstrap
├── requirements.txt             # Primary dependencies (PyQt6, requests)
├── README.md                   # User guide and setup instructions
├── PROJECT_CONTEXT.md          # Agent & developer context document (this file)
│
├── app/
│   ├── __init__.py
│   ├── main_window.py          # Minimalist main window (URL input, buttons, queue, log)
│   ├── settings_window.py      # Settings dialog (output dirs, binary paths, local server config)
│   └── styles.py               # Windows 11 dark theme QSS stylesheet
│
├── core/
│   ├── __init__.py
│   ├── download_manager.py     # Thread-safe queue manager & concurrency coordinator
│   ├── download_task.py        # Task data model (ID, URL, status, progress, speed, ETA)
│   ├── format_selector.py      # Format string builder (bestvideo*+bestaudio/best, audio-only, etc.)
│   └── history_manager.py      # Lightweight persistent history (JSON/SQLite)
│
├── workers/
│   ├── __init__.py
│   └── download_worker.py      # QThread running yt-dlp CLI via safe subprocess (pipes stdout/stderr)
│
├── server/
│   ├── __init__.py
│   └── local_server.py         # Standard library http.server daemon (localhost 127.0.0.1 only)
│
├── services/
│   ├── __init__.py
│   ├── ytdlp_manager.py        # yt-dlp binary resolver, version checker & updater
│   ├── ffmpeg_manager.py       # FFmpeg/FFprobe binary resolver & version checker
│   └── update_manager.py       # Safe download, verification, atomic replacement with backup
│
└── utils/
    ├── __init__.py
    ├── paths.py                # Resolution logic for runtime & binary search order
    ├── filenames.py            # Sanitization, path traversal checks, output templates
    └── logging_utils.py        # Redacted logging (strips tokens, passwords, cookies)
```

---

## 5. Security & Safety Principles

1. **Subprocess Safety**:
   - **NEVER** use `shell=True` or arbitrary shell string concatenation.
   - Always invoke executables using structured lists: `subprocess.Popen([exe_path, *args], ...)`.
2. **Local Server Safety**:
   - Default binding is strictly `127.0.0.1` (never `0.0.0.0` by default).
   - Validates all payload URLs and output paths.
   - Rejects arbitrary command strings or unauthorized executable execution.
3. **Privacy & Redaction**:
   - Never log or persist passwords, cookies, authentication tokens, or private credentials.
   - Zero telemetry: no user metrics or tracking calls sent to external servers.
4. **No DRM Circumvention**:
   - Do not implement DRM circumvention or unauthorized scraping bypasses.

---

## 6. Development Phases & Progress

| Phase | Description | Status |
|---|---|---|
| **Phase 0** | **Inspection and Plan**: Verify environment, inspect directory, check Parcel isolation, design architecture | **COMPLETED** |
| **Phase 1** | **Basic GUI**: URL bar, paste button, download button, basic worker, progress bar, binary detection | **COMPLETED** |
| **Phase 2** | **Download Queue**: Multi-task table (Status, Progress, Speed, ETA), Cancel, Retry, Remove | **COMPLETED** |
| **Phase 3** | **Advanced Options**: Audio-only, resolution select, container choice, embed metadata/subtitles | **COMPLETED** |
| **Phase 4** | **Settings and Session Memory**: Persistent config in portable app data, session memory toggle | **COMPLETED** |
| **Phase 5** | **Local Server**: Standard library API (`/health`, `/downloads`, download detail, cancel, retry) for browser extensions | **IN PROGRESS — detail endpoint and GUI server indicator pending** |
| **Phase 6** | **Update Management**: Version checks and atomic updates for `yt-dlp` and `FFmpeg` | **PARTIAL — verified replacement exists; update-check UI and trusted source metadata are pending** |
| **Phase 7** | **History and Polish**: History management, keyboard shortcuts, UI refinement | **COMPLETED** |
| **Phase 8** | **Packaging**: PyInstaller single Windows executable (`YTDLP-GUI.exe`) with bundled runtime | **COMPLETED — yt-dlp, FFmpeg, and FFprobe now bundled in bin/** |
| **Phase 9** | **Preset System**: 7 realistic presets (Best Quality, Music, Fast Import, Max Compatibility, Quick Access, Small File, Custom) | **COMPLETED** |

## 6.1 Master Prompt Compliance Follow-up

The current follow-up work tracks the remaining master-prompt requirements:

- Completed: `GET /downloads/{id}` endpoint and visible localhost server state/port in GUI.
- Completed: Redacted technical log UI (`QPlainTextEdit`) with toggle button.
- Completed: Explicit filename and output-path validation ([`utils/filenames.py`](file:///c:/Users/admin/Desktop/YT-DLP-GUI/utils/filenames.py)) preventing path traversal, system directory targeting, and shell character injection.
- Completed: Full standalone binaries bundled into `bin/` (`yt-dlp.exe`, `ffmpeg.exe`, `ffprobe.exe`).
- Completed: 7 standardized download presets implemented across [`core/preset_manager.py`](file:///c:/Users/admin/Desktop/YT-DLP-GUI/core/preset_manager.py), GUI dropdown sync with modified detection, and local API `/presets` and `POST /downloads` support.
- Pending: Advanced custom preset JSON import/export dialog.

---

## 7. Strict Communication & Anti-Hallucination Rules

Every agent interacting with this project must follow these rules:

1. **Section 25 Response Format**:
   - **Current phase**: State current phase name and number.
   - **Goal**: 1-2 sentence goal description.
   - **Files**: List files created or modified.
   - **Implementation**: Provide only code needed for current phase.
   - **Testing**: Provide exact commands executed and actual output.
   - **Limitations**: What is not implemented yet.
   - **Next phase**: Propose the next phase without auto-starting it.
2. **Anti-Hallucination**:
   - Never claim a command succeeded without actual output.
   - Never invent test results, file contents, or installed packages.
   - If a feature is not yet built, write: `"Planned, not implemented."`
   - If a test was not run, write: `"Not tested in this environment."`
3. **Work Incrementally**:
   - Do not generate multiple phases at once. Complete and verify each phase methodically.
