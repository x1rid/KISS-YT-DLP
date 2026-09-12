param(
    [string]$Executable = (Join-Path $PSScriptRoot 'dist\YTDLP-GUI.exe')
)

$ErrorActionPreference = 'Stop'
$python = Join-Path $PSScriptRoot '.venv\Scripts\python.exe'

if (-not (Test-Path $Executable)) {
    throw "Build artifact not found: $Executable"
}
if (-not (Test-Path $python)) {
    throw 'Project virtual environment not found.'
}

& $python -c "from PyQt6.QtCore import PYQT_VERSION_STR, QT_VERSION_STR; assert PYQT_VERSION_STR == QT_VERSION_STR, f'PyQt {PYQT_VERSION_STR} and Qt {QT_VERSION_STR} differ'; print(f'PyQt={PYQT_VERSION_STR}; Qt={QT_VERSION_STR}')"
if ($LASTEXITCODE -ne 0) { throw 'PyQt/Qt version verification failed.' }

$archive = & (Join-Path $PSScriptRoot '.venv\Scripts\pyi-archive_viewer.exe') $Executable -l
if ($LASTEXITCODE -ne 0) { throw 'Unable to inspect PyInstaller archive.' }

if ($archive | Select-String -Pattern "'api-ms-win-|ucrtbase.dll") {
    throw 'Build contains Windows API-set or UCRT forwarder DLLs that can shadow the system runtime.'
}
foreach ($required in @('Qt6Core.dll', 'QtCore.pyd', 'qwindows.dll')) {
    if (-not ($archive | Select-String -SimpleMatch $required)) {
        throw "Build is missing required Qt runtime entry: $required"
    }
}

Get-FileHash $Executable -Algorithm SHA256 | Format-List Algorithm, Hash, Path
Write-Host 'Build archive verification passed.'
