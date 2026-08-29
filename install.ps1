# install fortune if not already installed
if (-not (Get-Command fortune -ErrorAction SilentlyContinue)) {
    winget install --id fortune
}

# copy content to APPDATA
$dest = Join-Path $env:APPDATA "utilitylimb"
if (-not (Test-Path $dest)) {
    Copy-Item -Path "utilitylimb" -Destination $dest -Recurse
}

# append a call to fortune in the profile (if not already present)
$line = "fortune '$dest'"
if (-not (Select-String -Path $PROFILE -Pattern ([regex]::Escape($line)) -Quiet)) {
    Add-Content -Path $PROFILE -Value $line
}
