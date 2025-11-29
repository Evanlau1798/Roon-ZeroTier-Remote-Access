# =================================================================================
#
# Roon + ZeroTier Automation Management Tool
#
# By Evanlau
#
# =================================================================================

# --- 0. LANGUAGE CONFIGURATION & DICTIONARY ---

# Set Console Encoding to UTF8 to display Chinese characters correctly
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Detect System Language
$culture = Get-UICulture
if ($culture.Name -match "^zh") {
    $Lang = "ZH"
}
else {
    $Lang = "EN"
}

# Language Dictionary
$Text = @{
    "ZH" = @{
        "AdminRequired"  = "需要系統管理員權限。"
        "RequestAdmin"   = "正在請求權限重新執行腳本..."
        "FatalError"     = "嚴重錯誤：找不到 ZeroTier 安裝路徑。"
        "InstallZTFirst" = "請確保您已安裝 ZeroTier One 客戶端。"
        "PressEnterExit" = "`n按 Enter 鍵離開。"
        "NetIdSelect"    = "--- 選擇 Network ID ---"
        "ActiveDetected" = "偵測到已啟動的 ZeroTier 網路："
        "CurrentTarget"  = " [目前設定目標]"
        "NoActiveNet"    = "未偵測到已啟動的 ZeroTier 網路。"
        "SavedInactive"  = "已儲存的目標 (目前未啟動): "
        "ManualEntry"    = "  [M] 手動輸入 Network ID"
        "CancelReturn"   = "  [C] 取消並返回主選單"
        "MakeSelection"  = "請選擇 (或按 Enter 取消)"
        "EnterManualId"  = "請輸入 16 位數的 Network ID (或按 Enter 取消)"
        "InvalidLength"  = "ID 長度錯誤，請重試。"
        "IdNotActive"    = "警告：您輸入的 ID 目前未啟動。確定要使用嗎？ [y/n]"
        "InvalidSel"     = "無效的選擇，請重試。"
        "PressEnterCont" = "按 Enter 鍵繼續..."
        "StartInstall"   = "`n--- 開始安裝 ---"
        "UsingId"        = "`n使用 Network ID: {0}"
        "ConfigSaved"    = "  [成功] 設定檔已儲存。"
        "ScriptCreated"  = "  [成功] 輔助腳本已建立。"
        "TaskCreated"    = "  [成功] 排程任務 '{0}' 已建立成功。"
        "TaskFailed"     = "建立排程任務失敗。"
        "RunFirstTime"   = "  正在執行第一次修正 (立即套用)..."
        "InstallDone"    = "`n安裝完成！"
        "EditTitle"      = "`n--- 修改已儲存的 ZeroTier Network ID ---"
        "NoConfig"       = "找不到設定檔，請先執行安裝。"
        "UpdateSuccess"  = "`n成功更新 Network ID 為 '{0}'。"
        "StartUninstall" = "`n--- 移除自動化設定 ---"
        "TaskRemoved"    = "  [成功] 排程任務 '{0}' 已移除。"
        "TaskNotFound"   = "  [資訊] 找不到排程任務，略過。"
        "DirRemoved"     = "  [成功] 目錄 '{0}' 已移除。"
        "DirNotFound"    = "  [資訊] 找不到腳本目錄，略過。"
        "UninstallDone"  = "`n移除完成！"
        "MenuTitle"      = "===================================="
        "MenuSub1"       = "     Roon ZeroTier 遠端連線工具    "
        "MenuSub2"       = "             By Evanlau           "
        "CurrentId"      = "目前已設定之目標 Network ID: {0}"
        "StatusNotInst"  = "狀態：尚未安裝"
        "ChooseOption"   = "請選擇功能："
        "Opt1"           = "  1. 安裝 / 重新安裝自動化排程"
        "Opt2"           = "  2. 修改已儲存的 Network ID"
        "Opt3"           = "  3. 移除所有自動化元件"
        "Opt4"           = "  4. 開啟 GitHub 頁面"
        "Opt5"           = "  5. 離開"
        "EnterChoice"    = "請輸入選項 [1-5]"
        "Exiting"        = "正在離開..."
        "UnexpectedErr"  = "發生未預期的錯誤: {0}"
    }

    "EN" = @{
        "AdminRequired"  = "Administrator privileges are required."
        "RequestAdmin"   = "Requesting elevation to re-run the script from its source..."
        "FatalError"     = "Fatal Error: Could not find the ZeroTier installation."
        "InstallZTFirst" = "Please ensure the ZeroTier One client is installed before running this script."
        "PressEnterExit" = "`nPress Enter to exit."
        "NetIdSelect"    = "--- Network ID Selection ---"
        "ActiveDetected" = "Active ZeroTier networks detected:"
        "CurrentTarget"  = " [CURRENT TARGET]"
        "NoActiveNet"    = "No active ZeroTier networks detected."
        "SavedInactive"  = "Saved Target (Currently Inactive): "
        "ManualEntry"    = "  [M] Manually enter a Network ID"
        "CancelReturn"   = "  [C] Cancel and return to main menu"
        "MakeSelection"  = "Please make a selection (or press Enter to cancel)"
        "EnterManualId"  = "Enter the 16-character Network ID (or press Enter to cancel)"
        "InvalidLength"  = "Invalid ID length. Please try again."
        "IdNotActive"    = "Warning: The ID you entered is not currently active. Are you sure you want to use it? [y/n]"
        "InvalidSel"     = "Invalid selection. Please try again."
        "PressEnterCont" = "Press Enter to continue..."
        "StartInstall"   = "`n--- Starting Installation ---"
        "UsingId"        = "`nUsing Network ID: {0}"
        "ConfigSaved"    = "  [OK] Configuration saved."
        "ScriptCreated"  = "  [OK] Helper script created."
        "TaskCreated"    = "  [OK] Scheduled task '{0}' has been created successfully."
        "TaskFailed"     = "Failed to create the scheduled task."
        "RunFirstTime"   = "  Running the fix for the first time (Applying now)..."
        "InstallDone"    = "`nInstallation Complete!"
        "EditTitle"      = "`n--- Edit Saved ZeroTier Network ID ---"
        "NoConfig"       = "No configuration file found. Please run the installation first."
        "UpdateSuccess"  = "`nSuccessfully updated Network ID to '{0}'."
        "StartUninstall" = "`n--- Uninstalling Automation ---"
        "TaskRemoved"    = "  [OK] Scheduled task '{0}' has been removed."
        "TaskNotFound"   = "  [INFO] Scheduled task not found, skipping."
        "DirRemoved"     = "  [OK] Directory '{0}' has been removed."
        "DirNotFound"    = "  [INFO] Script directory not found, skipping."
        "UninstallDone"  = "`nUninstallation Complete!"
        "MenuTitle"      = "=================================="
        "MenuSub1"       = " Roon ZeroTier Remote Access tool "
        "MenuSub2"       = "            By Evanlau            "
        "CurrentId"      = "Current Target Network ID: {0}"
        "StatusNotInst"  = "Status: Not Installed"
        "ChooseOption"   = "Please choose an option:"
        "Opt1"           = "  1. Install or Re-install Automation"
        "Opt2"           = "  2. Edit Saved ZeroTier Network ID"
        "Opt3"           = "  3. Uninstall All Automation Components"
        "Opt4"           = "  4. Open GitHub Repository"
        "Opt5"           = "  5. Exit"
        "EnterChoice"    = "Enter your choice [1-5]"
        "Exiting"        = "Exiting."
        "UnexpectedErr"  = "An unexpected error occurred: {0}"
    }
}

# Helper function to get text easily
function T ($Key) {
    return $Text[$Lang][$Key]
}

# --- SCRIPT START ---

# 1. AUTOMATIC ADMINISTRATOR ELEVATION
$scriptUrl = "https://roon.evanlau1798.com" 

if (-Not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Clear-Host
    Write-Warning (T "AdminRequired")
    Write-Host (T "RequestAdmin")
    
    $command = "Invoke-Expression (Invoke-RestMethod -Uri $scriptUrl)"
    $encodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($command))
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoExit", "-NoProfile", "-EncodedCommand", $encodedCommand
    exit
}

# --- GLOBAL VARIABLES & DYNAMIC PATH FINDING ---
function Get-ZeroTierCliPath {
    $regPath = "HKLM:\SOFTWARE\WOW6432Node\ZeroTier, Inc.\ZeroTier One"
    if (Test-Path $regPath) {
        $installLocation = Get-ItemProperty -Path $regPath -Name "InstallLocation" -ErrorAction SilentlyContinue
        if ($installLocation -and -not [string]::IsNullOrEmpty($installLocation.InstallLocation)) {
            $cliPath = Join-Path $installLocation.InstallLocation "zerotier-cli.bat"
            if (Test-Path $cliPath -PathType Leaf) { return $cliPath }
        }
    }
    $defaultPath = "C:\Program Files (x86)\ZeroTier\One\zerotier-cli.bat"
    if (Test-Path $defaultPath -PathType Leaf) { return $defaultPath }
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
    Write-Error (T "FatalError")
    Write-Warning (T "InstallZTFirst")
    Read-Host (T "PressEnterExit")
    exit
}

# --- HELPER SCRIPT CONTENT ---
$helperScriptContent = @"
# This script is run by the scheduled task.

`$configPath = "$configFullPath"
`$zeroTierCliPath = "$zeroTierCliPath"

if (-not (Test-Path `$zeroTierCliPath -PathType Leaf)) { Exit }
if (-not (Test-Path `$configPath -PathType Leaf)) { Exit }

`$targetNetworkId = (Get-Content `$configPath | ConvertFrom-Json).TargetNetworkId
if ([string]::IsNullOrEmpty(`$targetNetworkId)) { Exit }

try {
    # Force output to string array, join, then convert to avoid pipeline issues
    `$rawOutput = & `$zeroTierCliPath listnetworks -j
    if (`$rawOutput) {
        `$jsonStr = `$rawOutput -join "`n"
        if (`$jsonStr.Trim() -ne "[]") {
            `$connectedNetworks = `$jsonStr | ConvertFrom-Json
        }
    }
} catch {
    Exit
}

if (`$connectedNetworks) {
    foreach (`$network in `$connectedNetworks) {
        # Check both nwid and id
        `$netId = if (`$network.nwid) { `$network.nwid } else { `$network.id }
        
        if (`$netId -eq `$targetNetworkId) {
            
            # Find Interface Alias containing the ID
            try {
                `$targetProfile = Get-NetConnectionProfile | Where-Object { 
                    (`$_.InterfaceAlias -like "*`$(`$netId)*") -and (`$_.NetworkCategory -eq "Public") 
                }

                if (`$targetProfile) {
                    `$targetProfile | Set-NetConnectionProfile -NetworkCategory Private
                }
            } catch {}
            break 
        }
    }
}
"@

# --- FUNCTION: GET NETWORK ID FROM USER ---
function Get-TargetNetworkIdFromUser {
    $connectedNetworks = @()
    
    try { 
        # 1. Get Raw Output (Array of strings)
        $rawOutput = & $zeroTierCliPath listnetworks -j
        
        # 2. Join lines (Critical for JSON parsing)
        $jsonStr = $rawOutput -join "`n"

        # 3. Check for empty JSON array "[]" specifically
        if (-not [string]::IsNullOrWhiteSpace($jsonStr) -and $jsonStr.Trim() -ne "[]") {
            # 4. Convert and Force Array Type @()
            $connectedNetworks = @($jsonStr | ConvertFrom-Json)
        }
    }
    catch {}
    
    $savedTargetId = ""
    if (Test-Path $configFullPath) {
        try { $savedTargetId = (Get-Content $configFullPath | ConvertFrom-Json).TargetNetworkId } catch {}
    }

    while ($true) {
        Clear-Host
        Write-Host (T "NetIdSelect")
        
        $savedIdWasFoundInActiveList = $false
        $i = 1
        
        # Determine if we actually have valid networks to show
        $hasValidNetworks = $false

        if ($connectedNetworks.Count -gt 0) {
            
            foreach ($network in $connectedNetworks) {
                # [CRITICAL] Check properties exist before displaying
                # If $network is null or has no ID, skip it (Fixes Ghost Entry)
                $realId = if ($network.nwid) { $network.nwid } else { $network.id }
                
                if ([string]::IsNullOrEmpty($realId)) { continue }

                # If we get here, we have a valid network to show
                if (-not $hasValidNetworks) {
                    Write-Host (T "ActiveDetected")
                    $hasValidNetworks = $true
                }

                $isSavedTarget = (![string]::IsNullOrEmpty($savedTargetId) -and $realId -eq $savedTargetId)
                $dispName = if ($network.name) { $network.name } else { "(No Name)" }

                Write-Host -Object "  [$i] " -NoNewline
                Write-Host -Object "$dispName" -ForegroundColor Green -NoNewline
                Write-Host -Object " ($realId)" -ForegroundColor Yellow -NoNewline
                
                if ($isSavedTarget) {
                    Write-Host -Object (T "CurrentTarget") -ForegroundColor Cyan
                    $savedIdWasFoundInActiveList = $true
                }
                else {
                    Write-Host ""
                }
                $i++
            }
        }
        
        if (-not $hasValidNetworks) {
            Write-Warning (T "NoActiveNet")
        }
        
        if (-not $savedIdWasFoundInActiveList -and -not [string]::IsNullOrEmpty($savedTargetId)) {
            Write-Host "-----------------------------------------------------"
            Write-Host -Object (T "SavedInactive") -ForegroundColor Gray -NoNewline
            Write-Host -Object $savedTargetId -ForegroundColor Yellow
        }
        
        Write-Host "`n" (T "ManualEntry")
        Write-Host (T "CancelReturn")
        $choice = Read-Host (T "MakeSelection")

        if ($choice -eq 'c' -or [string]::IsNullOrEmpty($choice)) { return $null }
        if ($choice -eq 'm') {
            while ($true) {
                $manualId = Read-Host (T "EnterManualId")
                if ([string]::IsNullOrEmpty($manualId)) { break }

                if ($manualId.Length -ne 16) {
                    Write-Warning (T "InvalidLength")
                    continue
                }
                
                $isDetected = $false
                foreach ($network in $connectedNetworks) { 
                    $nId = if ($network.nwid) { $network.nwid } else { $network.id }
                    if ($nId -eq $manualId) { $isDetected = $true; break } 
                }
                
                if (-not $isDetected) {
                    $confirm = Read-Host (T "IdNotActive")
                    if ($confirm -ne 'y') { continue }
                }
                return $manualId
            }
            continue
        }

        if ($choice -match '^\d+$' -and [int]$choice -ge 1 -and [int]$choice -le $connectedNetworks.Count) {
            $selectedNet = $connectedNetworks[[int]$choice - 1]
            
            # [FIXED] Use standard if/else block instead of return if(...)
            if ($selectedNet.nwid) { 
                return $selectedNet.nwid 
            }
            else { 
                return $selectedNet.id 
            }
        }

        Write-Warning (T "InvalidSel")
        Read-Host (T "PressEnterCont")
    }
}

# --- FUNCTION: INSTALLATION ---
function Start-Installation {
    Write-Host (T "StartInstall") -ForegroundColor Yellow

    $targetNetworkId = Get-TargetNetworkIdFromUser
    if ([string]::IsNullOrEmpty($targetNetworkId)) { return }

    Write-Host ((T "UsingId") -f $targetNetworkId)
    
    if (-not (Test-Path $installPath)) { New-Item -ItemType Directory -Path $installPath | Out-Null }
    @{ TargetNetworkId = $targetNetworkId } | ConvertTo-Json | Set-Content -Path $configFullPath
    Write-Host (T "ConfigSaved") -ForegroundColor Green
    
    Set-Content -Path $helperScriptFullPath -Value $helperScriptContent
    Write-Host (T "ScriptCreated") -ForegroundColor Green

    $taskRunCommand = "powershell.exe -ExecutionPolicy Bypass -File `"$helperScriptFullPath`""
    $xPathQuery = "*[System[EventID=10000]]"
    $eventChannel = "Microsoft-Windows-NetworkProfile/Operational"
    schtasks /Create /TN $taskName /TR "$taskRunCommand" /SC ONEVENT /EC $eventChannel /MO "$xPathQuery" /RU "SYSTEM" /F | Out-Null
    
    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        Write-Host ((T "TaskCreated") -f $taskName) -ForegroundColor Green
    }
    else {
        Write-Warning (T "TaskFailed")
        Read-Host (T "PressEnterCont")
        return
    }
    
    Write-Host (T "RunFirstTime") -ForegroundColor Cyan
    Invoke-Expression -Command $helperScriptContent
    
    Write-Host (T "InstallDone") -ForegroundColor Yellow
    Read-Host (T "PressEnterCont")
}

# --- FUNCTION: EDIT CONFIG ---
function Edit-Config {
    Write-Host (T "EditTitle") -ForegroundColor Yellow
    if (-not (Test-Path $configFullPath)) {
        Write-Warning (T "NoConfig")
        Read-Host (T "PressEnterCont")
        return
    }
    
    $newNetworkId = Get-TargetNetworkIdFromUser
    if ([string]::IsNullOrEmpty($newNetworkId)) { return }

    @{ TargetNetworkId = $newNetworkId } | ConvertTo-Json | Set-Content -Path $configFullPath
    Write-Host ((T "UpdateSuccess") -f $newNetworkId) -ForegroundColor Green
    
    # Immediately apply changes
    Write-Host (T "RunFirstTime") -ForegroundColor Cyan
    Invoke-Expression -Command $helperScriptContent

    Read-Host (T "PressEnterCont")
}

# --- FUNCTION: UNINSTALL ---
function Start-Uninstallation {
    Write-Host (T "StartUninstall") -ForegroundColor Yellow

    if (Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue) {
        schtasks /Delete /TN $taskName /F | Out-Null
        Write-Host ((T "TaskRemoved") -f $taskName) -ForegroundColor Green
    }
    else { Write-Host (T "TaskNotFound") -ForegroundColor Gray }

    if (Test-Path $installPath) {
        Remove-Item -Path $installPath -Recurse -Force
        Write-Host ((T "DirRemoved") -f $installPath) -ForegroundColor Green
    }
    else { Write-Host (T "DirNotFound") -ForegroundColor Gray }

    Write-Host (T "UninstallDone") -ForegroundColor Yellow
    Read-Host (T "PressEnterCont")
}

# --- MAIN MENU LOOP ---
while ($true) {
    Clear-Host
    Write-Host (T "MenuTitle")
    Write-Host (T "MenuSub1")
    Write-Host (T "MenuSub2")
    Write-Host (T "MenuTitle")
    
    Write-Host "-----------------------------------------------"
    if (Test-Path $configFullPath) {
        try {
            $currentId = (Get-Content $configFullPath | ConvertFrom-Json).TargetNetworkId
            Write-Host ((T "CurrentId") -f $currentId) -ForegroundColor Cyan
        }
        catch {}
    }
    else {
        Write-Host (T "StatusNotInst") -ForegroundColor Yellow
    }
    Write-Host "-----------------------------------------------"
    Write-Host (T "ChooseOption")
    Write-Host
    Write-Host (T "Opt1")
    Write-Host (T "Opt2")
    Write-Host (T "Opt3")
    Write-Host (T "Opt4")
    Write-Host (T "Opt5")
    Write-Host

    $choice = Read-Host (T "EnterChoice")

    try {
        switch ($choice) {
            "1" { Start-Installation }
            "2" { Edit-Config }
            "3" { Start-Uninstallation }
            "4" { Start-Process "https://github.com/Evanlau1798/Roon-ZeroTier-Remote-Access" }
            "5" { 
                Write-Host (T "Exiting")
                exit 
            }
            default {
                Write-Warning (T "InvalidSel")
                Read-Host (T "PressEnterCont")
            }
        }
    }
    catch {
        Write-Warning ((T "UnexpectedErr") -f $_.Exception.Message)
        Read-Host (T "PressEnterCont")
    }
}