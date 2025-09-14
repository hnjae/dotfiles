#!/usr/bin/env pwsh

# NOTE: 이 스크립트는 LLM 이 작성했으며, 따로 검증하지 않았음. <2025-09-11>
# Windows Registry Files Batch Executor
# This script applies all .reg files in the registries/ directory

# Check if running on Windows
if ($PSVersionTable.Platform -ne $null -and $PSVersionTable.Platform -ne "Win32NT") {
    Write-Error "This script can only run on Microsoft Windows."
    exit 1
}

# Alternative check for older PowerShell versions
if ([System.Environment]::OSVersion.Platform -ne [System.PlatformID]::Win32NT) {
    Write-Error "This script can only run on Microsoft Windows."
    exit 1
}

Write-Host "Detected Microsoft Windows. Proceeding with registry modifications..." -ForegroundColor Green

# Define the registries directory path
$registriesPath = Join-Path -Path $PSScriptRoot -ChildPath "registries"

# Check if registries directory exists
if (-not (Test-Path -Path $registriesPath -PathType Container)) {
    Write-Error "Registries directory not found at: $registriesPath"
    exit 1
}

# Get all .reg files in the directory
$regFiles = Get-ChildItem -Path $registriesPath -Filter "*.reg" | Sort-Object Name

if ($regFiles.Count -eq 0) {
    Write-Warning "No .reg files found in the registries directory."
    exit 0
}

Write-Host "Found $($regFiles.Count) registry files to process:" -ForegroundColor Cyan
foreach ($file in $regFiles) {
    Write-Host "  - $($file.Name)" -ForegroundColor Yellow
}

# Confirm before proceeding
$confirmation = Read-Host "`nDo you want to apply all these registry files? (y/N)"
if ($confirmation -ne 'y' -and $confirmation -ne 'Y') {
    Write-Host "Operation cancelled by user." -ForegroundColor Yellow
    exit 0
}

# Check for Administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if (-not $isAdmin) {
    Write-Warning "Administrator privileges recommended for registry modifications."
    $proceed = Read-Host "Continue anyway? (y/N)"
    if ($proceed -ne 'y' -and $proceed -ne 'Y') {
        Write-Host "Operation cancelled. Run as Administrator for best results." -ForegroundColor Yellow
        exit 0
    }
}

Write-Host "`nApplying registry files..." -ForegroundColor Green

$successCount = 0
$failureCount = 0

foreach ($regFile in $regFiles) {
    Write-Host "Processing: $($regFile.Name)..." -ForegroundColor Cyan

    try {
        # Use reg.exe to import the registry file
        $process = Start-Process -FilePath "reg.exe" -ArgumentList "import", "`"$($regFile.FullName)`"" -Wait -PassThru -WindowStyle Hidden

        if ($process.ExitCode -eq 0) {
            Write-Host "  ✓ Successfully applied $($regFile.Name)" -ForegroundColor Green
            $successCount++
        } else {
            Write-Host "  ✗ Failed to apply $($regFile.Name) (Exit code: $($process.ExitCode))" -ForegroundColor Red
            $failureCount++
        }
    }
    catch {
        Write-Host "  ✗ Error applying $($regFile.Name): $($_.Exception.Message)" -ForegroundColor Red
        $failureCount++
    }
}

# Summary
Write-Host "`n" + "="*50 -ForegroundColor Cyan
Write-Host "Registry Application Summary:" -ForegroundColor Cyan
Write-Host "  Successfully applied: $successCount" -ForegroundColor Green
Write-Host "  Failed: $failureCount" -ForegroundColor $(if ($failureCount -gt 0) { "Red" } else { "Green" })
Write-Host "="*50 -ForegroundColor Cyan

if ($failureCount -gt 0) {
    Write-Host "`nSome registry files failed to apply. Check the output above for details." -ForegroundColor Yellow
    exit 1
} else {
    Write-Host "`nAll registry files applied successfully!" -ForegroundColor Green
    Write-Host "Note: Some changes may require a system restart to take effect." -ForegroundColor Yellow
}
