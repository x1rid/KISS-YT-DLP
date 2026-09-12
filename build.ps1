param(
    [switch]$Clean
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$python = Join-Path $projectRoot '.venv\Scripts\python.exe'

if (-not (Test-Path $python)) {
    throw 'Create the project virtual environment before building.'
}

if ($Clean) {
    Remove-Item -Recurse -Force (Join-Path $projectRoot 'build') -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force (Join-Path $projectRoot 'dist') -ErrorAction SilentlyContinue
}

Push-Location $projectRoot
try {
    & $python -m PyInstaller --noconfirm --clean (Join-Path $projectRoot 'YTDLP-GUI.spec')
    if ($LASTEXITCODE -ne 0) {
        throw 'Packaging failed.'
    }
}
finally {
    Pop-Location
}

Write-Host "Portable executable created: $(Join-Path $projectRoot 'dist\YTDLP-GUI.exe')"
