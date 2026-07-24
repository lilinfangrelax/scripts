# Build CapsLockCtrl.exe from CapsLockCtrl.ahk
# Usage: .\build.ps1 [-Version 1.0.0]

param(
    [string]$Version = "1.0.0"
)

$ErrorActionPreference = "Stop"
Push-Location $PSScriptRoot

$Ahk2Exe = "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
$Base    = "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"
$Script  = "CapsLockCtrl.ahk"
$Output  = "CapsLockCtrl.exe"

# Create a temp copy with the requested version
$tempScript = [System.IO.Path]::GetTempFileName() + ".ahk"
$content = Get-Content $Script -Raw
$content = $content -replace ';@Ahk2Exe-SetVersion\s+[\d.]+', ";@Ahk2Exe-SetVersion       $Version"
[System.IO.File]::WriteAllText($tempScript, $content, [System.Text.UTF8Encoding]::new($false))

try {
    Write-Host "Building CapsLockCtrl v$Version ..."
    $result = cmd /c """$Ahk2Exe"" /in ""$tempScript"" /out ""$Output"" /base ""$Base""" 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: $result"
        exit 1
    }
    $info = (Get-Item $Output).VersionInfo
    Write-Host "Done: $Output"
    Write-Host "  File:       $($info.FileVersion)"
    Write-Host "  Product:    $($info.ProductVersion)"
    Write-Host "  Desc:       $($info.FileDescription)"
    Write-Host "  Size:       $((Get-Item $Output).Length) bytes"
} finally {
    Remove-Item $tempScript -Force -ErrorAction SilentlyContinue
    Pop-Location
}
