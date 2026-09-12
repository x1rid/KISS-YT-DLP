@echo off
cd /d "%~dp0"
if not exist "downloads" mkdir downloads
if not exist "data" mkdir data
start "" ".\.venv\Scripts\pythonw.exe" "main.py"
