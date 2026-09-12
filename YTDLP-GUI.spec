# -*- mode: python ; coding: utf-8 -*-
"""PyInstaller specification for the portable Windows application."""

from pathlib import Path

project_root = Path(SPECPATH)
data_files = []
# Bundle only optional executables. User settings/history stay next to the
# executable at runtime and must never be baked into a release artifact.
source = project_root / "bin"
if source.exists():
    data_files.append((str(source), "bin"))

analysis = Analysis(
    [str(project_root / "main.py")],
    pathex=[str(project_root)],
    binaries=[],
    datas=data_files,
    hiddenimports=["PyQt6.sip"],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
)
# These are Windows system API-set/UCRT forwarders, not application assets.
# If bundled beside Qt6Core.dll they can shadow the host versions and cause
# "specified procedure could not be found" while importing PyQt6.QtCore.
analysis.binaries = [
    entry for entry in analysis.binaries
    if not Path(entry[0]).name.lower().startswith("api-ms-win-")
    and Path(entry[0]).name.lower() != "ucrtbase.dll"
]
pyz = PYZ(analysis.pure)
exe = EXE(
    pyz,
    analysis.scripts,
    analysis.binaries,
    analysis.datas,
    [],
    name="YTDLP-GUI",
    console=False,
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=False,
)
