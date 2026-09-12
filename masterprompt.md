# \# IMPLEMENTATION PROMPT — ONE-CLICK DOWNLOAD, AUTO-PASTE, PRESET FOLDERS, AND QUALITY FALLBACK FOR YTDLP-GUI

# 

# You are modifying an existing standalone Windows desktop application named \*\*YTDLP-GUI\*\*.

# 

# This task is separate from the broader preset-system implementation.

# 

# Do not integrate Parcel code, branding, features, or architecture.

# 

# Implement the following workflow improvements while preserving the existing download manager, queue, settings system, and local API wherever possible.

# 

# Do not rewrite the whole application.

# 

# \---

# 

# \# 1. PRIMARY USER EXPERIENCE

# 

# The intended workflow is:

# 

# ```text

# Select preset once

# &#x20;       ↓

# Paste a URL

# &#x20;       ↓

# Download starts

# ```

# 

# The user should not need to repeatedly configure quality settings.

# 

# The main window should make this workflow seamless:

# 

# ```text

# \[ Preset: Best Quality ▼ ]    \[ Advanced Settings ]

# 

# \[ Paste video URL                                      ]

# 

# \[ Download ]

# ```

# 

# The preset and Advanced Settings controls must be positioned side by side above the video URL field.

# 

# The URL field should remain the main focus.

# 

# The application should support both:

# 

# ```text

# Paste → click Download

# ```

# 

# and, optionally:

# 

# ```text

# Ctrl + V → automatic download

# ```

# 

# \---

# 

# \# 2. ONE-CLICK DOWNLOAD DEFINITION

# 

# For this feature, “one-click download” means:

# 

# 1\. The user selects a preset.

# 2\. The user pastes a URL into the video field.

# 3\. The user clicks the Download button.

# 4\. The application immediately creates a queue item.

# 5\. The shared download manager starts processing the item.

# 6\. The selected preset determines the quality, format, processing, and destination folder.

# 

# The user should not need to open Advanced Settings during normal use.

# 

# Do not add unnecessary confirmation dialogs when the selected preset can be applied safely.

# 

# The selected preset must remain active for future downloads until the user changes it.

# 

# \---

# 

# \# 3. CTRL + V AUTO-DOWNLOAD

# 

# Add an optional setting:

# 

# ```text

# Automatically download when pasting a supported URL

# ```

# 

# Default:

# 

# ```text

# Enabled

# ```

# 

# When enabled:

# 

# \* Detect when the user pastes a supported URL using `Ctrl + V`.

# \* Paste the URL into the video field.

# \* Validate that the text is a supported URL.

# \* Automatically start the download.

# \* Use the currently selected preset.

# \* Use the selected preset’s download folder.

# \* Add the download to the existing shared queue.

# \* Trigger only once per paste event.

# \* Avoid duplicate downloads.

# \* Do not trigger for ordinary text.

# \* Do not trigger for unsupported or invalid URLs.

# 

# When disabled:

# 

# \* `Ctrl + V` should only paste the URL.

# \* The user must click Download manually.

# 

# The setting must be persistent.

# 

# \## Important implementation details

# 

# Do not rely only on a generic text-change event if that could trigger downloads when:

# 

# \* Text is typed manually.

# \* Text is changed programmatically.

# \* The field is cleared.

# \* A URL is edited.

# \* The same URL is pasted more than once unintentionally.

# 

# Use appropriate paste-event handling or another reliable method supported by the existing GUI framework.

# 

# Do not block normal clipboard behavior.

# 

# Do not trigger an automatic download before the pasted URL has been inserted and validated.

# 

# \---

# 

# \# 4. AUTO-DOWNLOAD STATUS AND USER FEEDBACK

# 

# When auto-download is enabled, show a small unobtrusive hint:

# 

# ```text

# Paste a URL to download automatically

# ```

# 

# When disabled, show:

# 

# ```text

# Paste a URL, then click Download

# ```

# 

# Do not create a large banner or repeated dialog.

# 

# The user must be able to understand whether Ctrl + V will start a download.

# 

# If auto-download fails, show a clear error and leave the URL available for manual retry.

# 

# \---

# 

# \# 5. LOCAL API DEFAULT STATE

# 

# The local API must be enabled by default.

# 

# The API must remain local-only.

# 

# Requirements:

# 

# \* Bind only to `localhost` or the loopback interface.

# \* Do not expose the API to the public network by default.

# \* Start automatically with the application if the existing architecture supports this.

# \* Provide a Settings option to disable the API.

# \* Display the API status in Settings.

# \* Use the same download queue as GUI downloads.

# \* Use the same preset system as GUI downloads.

# \* Use the same output-folder logic as GUI downloads.

# 

# Do not create a second API server if one already exists.

# 

# Do not create a second queue for API downloads.

# 

# \## API behavior

# 

# If an API request includes a preset:

# 

# ```json

# {

# &#x20; "url": "https://example.com/video",

# &#x20; "preset": "best\_quality"

# }

# ```

# 

# Use the requested preset after validating its ID.

# 

# If an API request does not include a preset:

# 

# ```json

# {

# &#x20; "url": "https://example.com/video"

# }

# ```

# 

# Use the application’s currently selected default preset.

# 

# Reject:

# 

# \* Invalid preset IDs.

# \* Invalid URLs.

# \* Arbitrary preset file paths.

# \* Arbitrary shell commands.

# \* Requests attempting to execute external commands.

# 

# \---

# 

# \# 6. DEFAULT DOWNLOAD DIRECTORY

# 

# By default, downloads should go to the `downloads` folder inside the YTDLP-GUI directory.

# 

# Conceptually:

# 

# ```text

# YTDLP-GUI/

# └── downloads/

# ```

# 

# The application should create the folder automatically when needed.

# 

# The exact location must be resolved safely based on the existing project and packaging architecture.

# 

# Do not assume that the executable directory is always writable.

# 

# If the directory is not writable:

# 

# 1\. Detect the problem before downloading.

# 2\. Explain the problem clearly.

# 3\. Offer a safe writable fallback or folder selection.

# 4\. Do not report a false successful download.

# 5\. Do not silently save files somewhere unexpected.

# 

# Do not create a second unrelated download-directory setting if one already exists.

# 

# \---

# 

# \# 7. PRESET-SPECIFIC DOWNLOAD FOLDERS

# 

# Each preset must be able to define its own download folder.

# 

# Example:

# 

# ```text

# Best Quality

# → YTDLP-GUI\\downloads\\best-quality

# 

# Music — Best Audio

# → YTDLP-GUI\\downloads\\music

# 

# Video Editor — Fast Import

# → YTDLP-GUI\\downloads\\editor-fast

# 

# Video Editor — Maximum Compatibility

# → YTDLP-GUI\\downloads\\editor-compatible

# 

# Quick Access — Fastest

# → YTDLP-GUI\\downloads\\quick-access

# 

# Small File

# → YTDLP-GUI\\downloads\\small-file

# ```

# 

# These are example paths. Adapt them to the existing project structure.

# 

# Requirements:

# 

# \* Each preset stores its own output directory.

# \* The selected preset controls where new downloads are saved.

# \* The folder is visible through Advanced Settings or preset management.

# \* The user can choose a custom folder for a preset.

# \* The folder is persistent.

# \* The folder is validated before download.

# \* Missing folders can be created automatically.

# \* Invalid folders produce a clear error.

# \* API downloads use the same folder rules.

# \* Queue items display their destination where practical.

# 

# Do not silently use the application-wide folder when a preset-specific folder is configured.

# 

# \---

# 

# \# 8. RESET PRESET TO ORIGINAL FORM

# 

# Every preset must have a reset action:

# 

# ```text

# Reset preset

# ```

# 

# Resetting a preset must restore its original definition, including:

# 

# \* Original format selector.

# \* Original quality limits.

# \* Original audio behavior.

# \* Original container.

# \* Original codec settings.

# \* Original conversion behavior.

# \* Original metadata behavior.

# \* Original thumbnail behavior.

# \* Original subtitle behavior.

# \* Original filename behavior.

# \* Original download folder.

# \* Original FFmpeg requirements.

# \* Original fallback behavior.

# 

# For built-in presets:

# 

# \* Built-in definitions must remain immutable.

# \* User modifications must not permanently alter the built-in definition.

# \* Reset must restore the official built-in settings.

# \* The original built-in folder must also be restored.

# 

# For custom presets:

# 

# \* Clearly define whether Reset restores the saved version or the original creation state.

# \* Do not delete the custom preset accidentally.

# \* Ask for confirmation if resetting would discard meaningful user changes.

# 

# Keep these actions separate:

# 

# ```text

# Reset current preset

# ```

# 

# and:

# 

# ```text

# Reset all application settings

# ```

# 

# Do not make the reset action ambiguous.

# 

# \---

# 

# \# 9. PRESET AND ADVANCED SETTINGS PLACEMENT

# 

# The preset selector and Advanced Settings control must be side by side above the URL field.

# 

# Required conceptual layout:

# 

# ```text

# ┌─────────────────────────────────────────────────────────────┐

# │ \[ Best Quality ▼ ]                  \[ Advanced Settings ]   │

# │                                                             │

# │ \[ Paste video URL                                         ] │

# │                                                             │

# │ \[ Download ]                                                │

# └─────────────────────────────────────────────────────────────┘

# ```

# 

# Requirements:

# 

# \* Preset selection is visible immediately.

# \* Advanced Settings is accessible without navigating elsewhere.

# \* Both controls appear above the URL field.

# \* The URL field remains easy to use.

# \* The Download button remains prominent.

# \* The layout works at smaller window sizes.

# \* Do not place these controls deep inside a settings page.

# \* Do not require the user to open Advanced Settings to select ordinary quality presets.

# 

# The interface should communicate:

# 

# ```text

# Choose quality once.

# Paste and download repeatedly.

# ```

# 

# \---

# 

# \# 10. QUALITY SELECTION AND ACTUAL AVAILABILITY

# 

# A preset is a preference, not a guarantee.

# 

# The application must check actual available formats when needed.

# 

# Do not assume that every URL has:

# 

# ```text

# 144p

# 240p

# 360p

# 480p

# 720p

# 1080p

# 1440p

# 2160p

# ```

# 

# Only display resolutions, codecs, and audio qualities returned by yt-dlp metadata.

# 

# Do not claim that a video is available in 4K, 8K, HDR, or a specific codec before checking.

# 

# \---

# 

# \# 11. WHEN THE REQUESTED QUALITY IS UNAVAILABLE

# 

# If the selected preset requests a quality that is not available, the application must not silently pretend that the requested quality was downloaded.

# 

# Example:

# 

# ```text

# Requested quality: 2160p

# 

# Actually available:

# 1080p

# 720p

# 480p

# ```

# 

# The application should provide a clear prompt such as:

# 

# ```text

# The selected quality is unavailable.

# 

# Requested:

# 2160p

# 

# Available:

# 1080p

# 720p

# 480p

# 

# \[ Download 1080p ]

# \[ Choose another quality ]

# \[ Cancel ]

# ```

# 

# For audio:

# 

# ```text

# The selected audio format is unavailable.

# 

# Available:

# Opus

# M4A

# 

# \[ Use Opus ]

# \[ Use M4A ]

# \[ Cancel ]

# ```

# 

# The prompt must be based on actual extracted metadata.

# 

# Do not show fictional or guessed options.

# 

# \---

# 

# \# 12. UNAVAILABLE-QUALITY POLICY

# 

# Add a configurable setting:

# 

# ```text

# When the selected quality is unavailable:

# ```

# 

# Possible options:

# 

# ```text

# 1\. Automatically use the best available quality.

# 2\. Ask before a meaningful downgrade.

# 3\. Cancel the download.

# 4\. Use the closest available quality without asking.

# ```

# 

# The user must be able to change this behavior in Settings.

# 

# Recommended initial behavior:

# 

# ```text

# Ask before a meaningful downgrade.

# ```

# 

# However, do not finalize this default if the existing UX suggests another choice. Ask the user before making a major decision.

# 

# A practical implementation may distinguish between:

# 

# \* Minor fallback, such as 1080p to 720p.

# \* Major fallback, such as 4K to 480p.

# \* Missing requested codec.

# \* Missing requested audio format.

# \* Missing separate video/audio streams.

# \* Missing FFmpeg-dependent functionality.

# 

# The application should explain the actual fallback:

# 

# ```text

# Using 1080p because 1440p is unavailable.

# ```

# 

# Do not silently downgrade when the selected policy requires confirmation.

# 

# \---

# 

# \# 13. USER DECISION REQUIRED IF BEHAVIOR IS AMBIGUOUS

# 

# If the implementation requires a product decision, ask the user using concrete options.

# 

# For example:

# 

# ```text

# The selected quality is unavailable. Which behavior should YTDLP-GUI use?

# 

# 1\. Always use the best available quality automatically.

# 2\. Ask only when the downgrade is significant.

# 3\. Always ask before using a lower quality.

# 4\. Cancel unless the exact requested quality exists.

# ```

# 

# Do not make major quality-fallback decisions based on assumptions.

# 

# Continue implementing unrelated parts only if they do not depend on the unanswered decision.

# 

# \---

# 

# \# 14. PRESET MODIFICATION BEHAVIOR

# 

# When the user changes Advanced Settings while a preset is selected:

# 

# \* Detect that the preset no longer matches its original settings.

# \* Display a modified state such as:

# 

# ```text

# Best Quality — Modified

# ```

# 

# or:

# 

# ```text

# Custom

# ```

# 

# \* Do not overwrite the built-in preset.

# \* Provide:

# 

# ```text

# Save as new preset

# ```

# 

# \* Provide:

# 

# ```text

# Reset preset

# ```

# 

# The modified state should include changes to:

# 

# \* Format.

# \* Resolution.

# \* Audio mode.

# \* Container.

# \* Codec.

# \* Conversion.

# \* Metadata.

# \* Thumbnail.

# \* Subtitles.

# \* Filename.

# \* Download folder.

# \* Other relevant download settings.

# 

# \---

# 

# \# 15. DOWNLOAD QUEUE INTEGRATION

# 

# All downloads must use the existing shared download manager and queue.

# 

# This includes downloads started through:

# 

# \* Download button.

# \* Ctrl + V auto-download.

# \* Local API.

# \* Preset selection.

# \* Future browser-extension integration.

# 

# Do not create separate download logic for each entry point.

# 

# The queue item should retain:

# 

# \* Source URL.

# \* Selected preset ID.

# \* Preset name at the time of submission.

# \* Effective settings.

# \* Output folder.

# \* Requested quality.

# \* Actual selected quality when known.

# \* Current status.

# \* Error information.

# 

# The preset should be resolved at queue-item creation time so later preset changes do not unexpectedly alter already queued downloads.

# 

# \---

# 

# \# 16. DOWNLOAD STATUS

# 

# Support clear statuses such as:

# 

# ```text

# Preparing

# Fetching metadata

# Checking available formats

# Waiting for user choice

# Downloading

# Merging

# Remuxing

# Converting

# Embedding metadata

# Completed

# Failed

# Cancelled

# ```

# 

# Do not display `Downloading 100%` while FFmpeg merging or conversion is still running.

# 

# When a quality fallback occurs, show the actual result.

# 

# Example:

# 

# ```text

# Completed — downloaded at 1080p because 1440p was unavailable

# ```

# 

# \---

# 

# \# 17. SETTINGS TO ADD OR INTEGRATE

# 

# Use the existing settings architecture.

# 

# Do not create a second settings system.

# 

# Add or integrate:

# 

# ```text

# Automatically download when pasting a supported URL

# ```

# 

# Default:

# 

# ```text

# Enabled

# ```

# 

# ```text

# Enable local API

# ```

# 

# Default:

# 

# ```text

# Enabled

# ```

# 

# ```text

# Default preset

# ```

# 

# ```text

# Default download folder

# ```

# 

# ```text

# When selected quality is unavailable

# ```

# 

# Possible values:

# 

# ```text

# Automatic best available

# Ask before meaningful downgrade

# Always ask

# Cancel

# ```

# 

# The application-level default folder should be:

# 

# ```text

# <YTDLP-GUI directory>\\downloads

# ```

# 

# Preset-specific folders should override the application-level folder when configured.

# 

# \---

# 

# \# 18. TESTING REQUIREMENTS

# 

# Test each feature independently.

# 

# \## Manual one-click download

# 

# \* Select a preset.

# \* Paste a valid URL.

# \* Click Download.

# \* Confirm the selected preset is used.

# \* Confirm the correct output folder is used.

# \* Confirm the item enters the shared queue.

# 

# \## Ctrl + V auto-download

# 

# \* Enable auto-download.

# \* Paste a supported URL.

# \* Confirm exactly one download starts.

# \* Paste ordinary text.

# \* Confirm no download starts.

# \* Paste an invalid URL.

# \* Confirm appropriate handling.

# \* Disable auto-download.

# \* Confirm Ctrl + V only pastes.

# \* Paste the same URL twice intentionally.

# \* Confirm duplicate behavior is predictable.

# 

# \## Local API

# 

# \* Confirm API is enabled by default.

# \* Confirm it binds only to localhost.

# \* Submit a request with a preset.

# \* Submit a request without a preset.

# \* Confirm the default preset is used when no preset is supplied.

# \* Submit an invalid preset.

# \* Confirm the request is rejected safely.

# \* Confirm API downloads use the shared queue.

# \* Confirm API downloads use the correct preset folder.

# \* Disable the API and confirm requests are rejected.

# 

# \## Preset folders

# 

# \* Confirm every preset has an original folder.

# \* Change a preset’s folder.

# \* Download using that preset.

# \* Confirm the file is saved in the selected folder.

# \* Restart the application.

# \* Confirm the folder persists.

# \* Reset the preset.

# \* Confirm the original folder is restored.

# \* Test missing and unwritable folders.

# 

# \## Quality fallback

# 

# \* Requested quality exists.

# \* Requested quality does not exist.

# \* Several lower resolutions exist.

# \* Only combined formats exist.

# \* Separate video/audio streams exist.

# \* The user chooses an available fallback.

# \* The user cancels.

# \* Automatic fallback mode works.

# \* Exact-quality cancellation mode works.

# \* Actual selected resolution is shown correctly.

# 

# \---

# 

# \# 19. IMPLEMENTATION ORDER

# 

# Implement in this order:

# 

# \## Phase 1 — Inspect existing architecture

# 

# Identify:

# 

# \* Current settings model.

# \* Current download configuration.

# \* Current queue/download manager.

# \* Current GUI layout.

# \* Current URL field.

# \* Current paste handling.

# \* Current Download button behavior.

# \* Current local API implementation.

# \* Current API startup state.

# \* Current output-folder handling.

# \* Current FFmpeg and yt-dlp path handling.

# 

# \## Phase 2 — Preset folder model

# 

# Add:

# 

# \* Preset-specific folder.

# \* Default folder.

# \* Folder validation.

# \* Reset-to-original folder behavior.

# 

# \## Phase 3 — Main layout

# 

# Place:

# 

# ```text

# Preset selector + Advanced Settings

# ```

# 

# side by side above the URL field.

# 

# \## Phase 4 — Manual one-click workflow

# 

# Ensure the Download button uses:

# 

# \* Current preset.

# \* Effective settings.

# \* Correct folder.

# \* Shared queue.

# 

# \## Phase 5 — Ctrl + V auto-download

# 

# Add the setting and reliable paste detection.

# 

# \## Phase 6 — Local API defaults

# 

# Ensure the API is enabled by default and remains localhost-only.

# 

# \## Phase 7 — Quality availability handling

# 

# Add metadata inspection, fallback detection, prompts, and user-configurable behavior.

# 

# \## Phase 8 — Reset and modified-preset behavior

# 

# Add:

# 

# \* Modified detection.

# \* Reset preset.

# \* Save as new preset.

# \* Original built-in preset protection.

# 

# \## Phase 9 — Testing and cleanup

# 

# Test every workflow and remove duplicate or bypassed logic.

# 

# Do not implement all phases in one response.

# 

# \---

# 

# \# 20. STRICT DEVELOPMENT RULES

# 

# Before modifying code:

# 

# 1\. Inspect the existing project.

# 2\. Report the relevant files.

# 3\. Identify the current integration points.

# 4\. Do not invent files or functions.

# 5\. Do not create duplicate settings systems.

# 6\. Do not create duplicate download managers.

# 7\. Do not create duplicate API servers.

# 8\. Do not bypass the existing queue.

# 9\. Do not modify unrelated Parcel files.

# 10\. Do not silently downgrade quality against the selected policy.

# 11\. Do not claim a feature works without testing.

# 12\. Do not expose the local API publicly by default.

# 13\. Do not execute arbitrary shell commands from API or preset input.

# 14\. Do not assume a requested resolution exists.

# 15\. Do not overwrite built-in presets.

# 16\. Do not silently save files to an unexpected directory.

# 

# If a required component does not exist, state that clearly and implement the smallest necessary component.

# 

# If a product decision is unclear, ask the user with numbered options before implementing that part.

# 

# \---

# 

# \# 21. REQUIRED RESPONSE FORMAT

# 

# For every implementation phase, respond using:

# 

# \## Current phase

# 

# State the phase being implemented.

# 

# \## Findings

# 

# Explain what exists in the current project.

# 

# \## Files to modify

# 

# List exact files.

# 

# \## Implementation

# 

# Provide only the code required for this phase.

# 

# \## Testing

# 

# Provide exact commands or manual tests.

# 

# \## Expected result

# 

# Explain the expected behavior.

# 

# \## Limitations

# 

# State what is not implemented.

# 

# \## Decisions needed

# 

# Ask only the questions that are necessary for the next phase.

# 

# \---

# 

# \# FINAL INSTRUCTION

# 

# Start by inspecting the existing YTDLP-GUI project.

# 

# Do not implement the full system immediately.

# 

# First report:

# 

# 1\. Current settings architecture.

# 2\. Current download configuration.

# 3\. Current download queue.

# 4\. Current GUI layout.

# 5\. Current URL paste handling.

# 6\. Current Download button behavior.

# 7\. Current local API implementation and default state.

# 8\. Current output-folder handling.

# 9\. Current FFmpeg/yt-dlp path handling.

# 10\. Recommended integration points.

# 11\. Phase 1 implementation plan.

# 12\. Any decisions requiring user confirmation.

# 

# Then wait before making code changes.



