# =================================================================================
# Roon + ZeroTier Automation Management Tool
#
# By Evanlau with Gemini
#
# =================================================================================

# --- SCRIPT START ---

# 1. AUTOMATIC ADMINISTRATOR ELEVATION
$scriptUrl = "https://roon.evanlau1798.com" # The URL for this script itself

if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Clear-Host
    Write-Warning "Administrator privileges are required."
    Write-Host "Requesting elevation to re-run the script from its source..."
    
    # Define the command to be run in the new admin window. It will re-download and execute this script.
    $command = "Invoke-Expression (Invoke-RestMethod -Uri $scriptUrl)"
    
    # PowerShell's -EncodedCommand argument requires the command to be in UTF-16LE, then Base64 encoded.
    $encodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($command))
    
    # Start the new process with the encoded command and then exit the current non-admin process.
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit", "-NoProfile", "-EncodedCommand", $encodedCommand
    exit
}

# --- GLOBAL VARIABLES & DYNAMIC PATH FINDING ---
function Get-ZeroTierCliPath {
    # Method 1: Check the registry (most reliable)
    $regPath = "HKLM:\SOFTWARE\WOW6432Node\ZeroTier, Inc.\ZeroTier One"
    if (Test-Path $regPath) {
        $installLocation = Get-ItemProperty -Path $regPath -Name "InstallLocation" -ErrorAction SilentlyContinue
        if ($installLocation -and -not [string]::IsNullOrEmpty($installLocation.InstallLocation)) {
            $cliPath = Join-Path $installLocation.InstallLocation "zerotier-cli.bat"
            if (Test-Path $cliPath -PathType Leaf) {
                return $cliPath
            }
        }
    }
    # Method 2: Fallback to default path
    $defaultPath = "C:\Program Files (x86)\ZeroTier\One\zerotier-cli.bat"
    if (Test-Path $defaultPath -PathType Leaf) {
        return $defaultPath
    }
    return $null
}

$installPath = "C:\ProgramData\RoonZeroTierSetup"
$helperScriptName = "Set-TargetZT-Private.ps1"
$configName = "config.json"
$taskName = "RoonZeroTier_AutoSetPrivate"
$helperScriptFullPath = Join-Path $installPath $helperScriptName
$configFullPath = Join-Path $installPath $configName
$zeroTierCliPath = Get-ZeroTierCliPath

# --- PRE-EXECUTION CHECK ---
if ([string]::IsNullOrEmpty($zeroTierCliPath)) {
    Clear-Host
    Write-Error "Fatal Error: Could not find the ZeroTier installation."
    Write-Warning "Please ensure the ZeroTier One client is installed before running this script."
    Read-Host "`nPress Enter to exit."
    exit
}

# --- HELPER SCRIPT CONTENT ---
$helperScriptContent = @"
# This script is run by the scheduled task.
# It uses the 'nwid' property to identify the target network interface.

`$configPath = "$configFullPath"
`$zeroTierCliPath = "$zeroTierCliPath"

if (-not (Test-Path `$zeroTierCliPath -PathType Leaf)) { Exit }
if (-not (Test-Path `$configPath -PathType Leaf)) { Exit }

`$targetNetworkId = (Get-Content `$configPath | ConvertFrom-Json).TargetNetworkId
if ([string]::IsNullOrEmpty(`$targetNetworkId)) { Exit }

try {
    `$connectedNetworks = & `$zeroTierCliPath listnetworks -j | ConvertFrom-Json
} catch {
    Exit
}

foreach (`$network in `$connectedNetworks) {
    if (`$network.id -eq `$targetNetworkId) {
        `$targetNwid = `$network.nwid
        if ([string]::IsNullOrEmpty(`$targetNwid)) { continue }

        try {
            `$targetProfile = Get-NetConnectionProfile | Where-Object { 
                (`$_.InterfaceAlias -like "*`$(`$targetNwid)*") -and (`$_.NetworkCategory -eq "Public") 
            }

            if (`$targetProfile) {
                `$targetProfile | Set-NetConnectionProfile -NetworkCategory Private
            }
        } catch {}
        break 
    }
}
"@

# --- FUNCTION: GET NETWORK ID FROM USER ---
function Get-TargetNetworkIdFromUser {
    $connectedNetworks = @()
    try { $connectedNetworks = & $zeroTierCliPath listnetworks -j | ConvertFrom-Json } catch {}
    
    $savedTargetId = ""
    if (Test-Path $configFullPath) {
        try { $savedTargetId = (Get-Content $configFullPath | ConvertFrom-Json).TargetNetworkId } catch {}
    }

    while ($true) {
        Clear-Host
        Write-Host "--- Network ID Selection ---"
        
        $savedIdWasFoundInActiveList = $false
        $i = 1

        if ($connectedNetworks.Count -gt 0) {
            Write-Host "Active ZeroTier networks detected:"
            foreach ($network in $connectedNetworks) {
                $isSavedTarget = (![string]::IsNullOrEmpty($savedTargetId) -and $network.id -eq $savedTargetId)
                
                Write-Host -Object "  [$i] " -NoNewline
                Write-Host -Object "$($network.name)" -ForegroundColor Green -NoNewline
                Write-Host -Object " ($($network.id))" -ForegroundColor Yellow -NoNewline
                
                if ($isSavedTarget) {
                    Write-Host -Object " [CURRENT TARGET]" -ForegroundColor Cyan
                    $savedIdWasFoundInActiveList = $true
                } else {
                    Write-Host ""
                }
                $i++
            }
        } else {
            Write-Warning "No active ZeroTier networks detected."
        }
        
        if (-not $savedIdWasFoundInActiveList -and -not [string]::IsNullOrEmpty($savedTargetId)) {
            Write-Host "-----------------------------------------------------"
            Write-Host -Object "Saved Target (Currently Inactive): " -ForegroundColor Gray -NoNewline
            Write-Host -Object $savedTargetId -ForegroundColor Yellow
        }
        
        Write-Host "`n  [M] Manually enter a Network ID"
        Write-Host "  [C] Cancel and return to main menu"
        $choice = Read-Host "Please make a selection (or press Enter to cancel)"

        if ($choice -eq 'c' -or [string]::IsNullOrEmpty($choice)) { return $null }
        if ($choice -eq 'm') {
            while ($true) {
                $manualId = Read-Host "Enter the 16-character Network ID (or press Enter to cancel)"
                if ([string]::IsNullOrEmpty($manualId)) { break }

                if ($manualId.Length -ne 16) {
                    Write-Warning "Invalid ID length. Please try again."
                    continue
                }
                
                $isDetected = $false
                foreach ($network in $connectedNetworks) { if ($network.id -eq $manualId) { $isDetected = $true; break } }
                
                if (-not $isDetected) {
                    $confirm = Read-Host "Warning: The ID you entered is not currently active. Are you sure you want to use it? [y/n]"
                    if ($confirm -ne 'y') { continue }
                }
                return $manualId
            }
            continue
        }

        if ($choice -match '^\d+$' -and [int]$choice -ge 1 -and [int]$choice -le $connectedNetworks.Count) {
            return $connectedNetworks[[int]$choice - 1].id
        }

        Write-Warning "Invalid selection. Please try again."
        Read-Host "Press Enter to continue..."
    }
}

# --- FUNCTION: INSTALLATION ---
function Start-Installation {
    Write-Host "`n--- Starting Installation ---" -ForegroundColor Yellow

    $targetNetworkId = Get-TargetNetworkIdFromUser
    if ([string]::IsNullOrEmpty($targetNetworkId)) { return }

    Write-Host "`nUsing Network ID: $targetNetworkId"
    
    if (-not (Test-Path $installPath)) { New-Item -ItemType Directory -Path $installPath | Out-Null }
    @{ TargetNetworkId = $targetNetworkId } | ConvertTo-Json | Set-Content -Path $configFullPath
    Write-Host "  [OK] Configuration saved." -ForegroundColor Green
    
    Set-Content -Path $helperScriptFullPath -Value $helperScriptContent
    Write-Host "  [OK] Helper script created." -ForegroundColor Green

    $taskRunCommand = "powershell.exe -ExecutionPolicy Bypass -File `"$helperScriptFullPath`""
    $xPathQuery = "*[System[EventID=10000]]"
    $eventChannel = "Microsoft-Windows-NetworkProfile/Operational"
    schtasks /Create /TN $taskName /TR "$taskRunCommand" /SC ONEVENT /EC $eventChannel /MO "$xPathQuery" /RU "SYSTEM" /F | Out-Null
    
    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        Write-Host "  [OK] Scheduled task '$taskName' has been created successfully." -ForegroundColor Green
    } else {
        Write-Warning "Failed to create the scheduled task."
        Read-Host "`nPress Enter to return to the menu..."
        return
    }
    
    # Using Invoke-Expression here to immediately run the newly created script content
    # ensuring the latest logic is applied right after installation.
    Write-Host "  Running the fix for the first time..." -ForegroundColor Cyan
    Invoke-Expression -Command $helperScriptContent
    
    Write-Host "`nInstallation Complete!" -ForegroundColor Yellow
    Read-Host "`nPress Enter to return to the menu..."
}

# --- FUNCTION: EDIT CONFIG ---
function Edit-Config {
    Write-Host "`n--- Edit Saved ZeroTier Network ID ---" -ForegroundColor Yellow
    if (-not (Test-Path $configFullPath)) {
        Write-Warning "No configuration file found. Please run the installation first."
        Read-Host "`nPress Enter to return to the menu..."
        return
    }
    
    $newNetworkId = Get-TargetNetworkIdFromUser
    if ([string]::IsNullOrEmpty($newNetworkId)) { return }

    @{ TargetNetworkId = $newNetworkId } | ConvertTo-Json | Set-Content -Path $configFullPath
    Write-Host "`nSuccessfully updated Network ID to '$newNetworkId'." -ForegroundColor Green
    Read-Host "`nPress Enter to return to the menu..."
}

# --- FUNCTION: UNINSTALL ---
function Start-Uninstallation {
    Write-Host "`n--- Uninstalling Automation ---" -ForegroundColor Yellow

    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        schtasks /Delete /TN $taskName /F | Out-Null
        Write-Host "  [OK] Scheduled task '$taskName' has been removed." -ForegroundColor Green
    } else { Write-Host "  [INFO] Scheduled task not found, skipping." -ForegroundColor Gray }

    if (Test-Path $installPath) {
        Remove-Item -Path $installPath -Recurse -Force
        Write-Host "  [OK] Directory '$installPath' has been removed." -ForegroundColor Green
    } else { Write-Host "  [INFO] Script directory not found, skipping." -ForegroundColor Gray }

    Write-Host "`nUninstallation Complete!" -ForegroundColor Yellow
    Read-Host "`nPress Enter to return to the menu..."
}

# --- MAIN MENU LOOP ---
while ($true) {
    Clear-Host
    # The title should reflect the final, most robust version
    Write-Host "=================================="
    Write-Host " Roon ZeroTier Remote Access tool "
    Write-Host "                                  "
    Write-Host "            By Evanlau            "
    Write-Host "=================================="
    if (Test-Path $configFullPath) {
        try {
            $currentId = (Get-Content $configFullPath | ConvertFrom-Json).TargetNetworkId
            Write-Host "Current Target Network ID: $currentId" -ForegroundColor Cyan
        } catch {}
    } else {
        Write-Host "Status: Not Installed" -ForegroundColor Yellow
    }
    Write-Host "-----------------------------------------------"
    Write-Host "Please choose an option:"
    Write-Host
    Write-Host "  1. Install or Re-install Automation"
    Write-Host "  2. Edit Saved ZeroTier Network ID"
    Write-Host "  3. Uninstall All Automation Components"
    Write-Host "  4. Exit"
    Write-Host

    $choice = Read-Host "Enter your choice [1-4]"

    try {
        switch ($choice) {
            "1" { Start-Installation }
            "2" { Edit-Config }
            "3" { Start-Uninstallation }
            "4" { 
                Write-Host "Exiting."
                exit 
            }
            default {
                Write-Warning "Invalid option. Please try again."
                Read-Host "`nPress Enter to return to the menu..."
            }
        }
    } catch {
        Write-Warning "An unexpected error occurred: $($_.Exception.Message)"
        Read-Host "`nPress Enter to return to the menu..."
    }
}