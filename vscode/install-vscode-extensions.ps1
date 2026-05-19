# Installs all VS Code extensions listed in vscode/extensions.txt

$extensionsFile = Join-Path $PSScriptRoot "..\vscode\extensions.txt"

if (-not (Test-Path $extensionsFile)) {
    Write-Host "extensions.txt not found: $extensionsFile" -ForegroundColor Red
    exit 1
}

Get-Content $extensionsFile | ForEach-Object {
    $extension = $_.Trim()

    if ($extension -ne "" -and -not $extension.StartsWith("#")) {
        Write-Host "Installing extension: $extension"
        code --install-extension $extension
    }
}

Write-Host "Done."
