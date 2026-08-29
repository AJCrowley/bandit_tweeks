# Get the directory containing this script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Install fortune if not already installed
$rfortune = Join-Path $env:ProgramFiles "rfortune\rfortune.exe"

if (-not (Test-Path $rfortune)) {

    $tempDir = Join-Path $env:TEMP "rfortune"
    $zipFile = Join-Path $env:TEMP "rfortune.zip"
    $installDir = Join-Path $env:ProgramFiles "rfortune"

    # Create temporary directory
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    # Download rFortune
    Invoke-WebRequest `
        -Uri "https://github.com/umpire274/rFortune/releases/download/v0.5.6/rfortune-0.5.6-x86_64-pc-windows-msvc.zip" `
        -OutFile $zipFile

    # Extract it
    Expand-Archive `
        -LiteralPath $zipFile `
        -DestinationPath $tempDir `
        -Force

    # Create installation directory
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null

    # Install executable
    Copy-Item `
        -Path (Join-Path $tempDir "rfortune.exe") `
        -Destination $rfortune `
        -Force

    # Clean up
    Remove-Item $zipFile -Force -ErrorAction SilentlyContinue
    Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue

    Write-Host "rFortune installed to $rfortune"
}

# Copy utilitylimb to APPDATA
$source = Join-Path $scriptDir "utilitylimb"
$dest = Join-Path $env:APPDATA "utilitylimb\utilitylimb"

if (-not (Test-Path $dest)) {
    Copy-Item -Path $source -Destination $dest -Recurse
}

# Append a call to rFortune in the profile (if not already present)
$line = "& `"$rfortune`" --file $dest"

if (-not (Select-String -Path $PROFILE -Pattern ([regex]::Escape($line)) -Quiet)) {
    Add-Content -Path $PROFILE -Value $line
}

# Initialize rfortune
Invoke-Expression $line
