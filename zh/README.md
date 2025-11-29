# Roon + ZeroTier 自動化管理工具

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://docs.microsoft.com/en-us/powershell/) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Status](https://img.shields.io/badge/status-working-brightgreen)](https://github.com/evanlau1798/Roon-ZeroTier-Remote-Access)

[English](../README.md) | [中文](README.md)

一個強大的選單式 PowerShell 腳本，用於自動化 Windows 上 Roon Server 使用 ZeroTier 的遠端存取設定。

此工具解決了 Roon 客戶端在外部網路無法發現 Roon Server 的常見問題，因為 Windows 通常將 ZeroTier 虛擬網路介面卡視為「公用 (Public)」網路。此腳本提供了一種安全、持久且使用者友善的方式來管理此自動化設定。

---

### 功能特色

*   **一鍵執行**: 簡單、無須繁瑣設定，直接在 PowerShell 中執行即可。
*   **多語言支援**: 自動偵測您的系統語言（支援英文與繁體中文）。
*   **選單式介面**: 易於使用的選單，可用於安裝、編輯設定和移除自動化元件。
*   **指定 Network ID**: 腳本僅針對 *特定* 的 ZeroTier Network ID 進行設定，確保您其他的 ZeroTier 連線保持安全且不受影響。
*   **智慧網路偵測**: 自動偵測已啟動的 ZeroTier 網路，讓選擇 ID 變得簡單且不易出錯。改進的解析邏輯能支援各種 ZeroTier CLI 輸出格式。
*   **即時套用**: 安裝或修改設定後會立即執行修正，無需重新啟動或等待排程觸發。
*   **顏色標示顯示**: 啟動的網路名稱與 ID 以顏色區分，提升可讀性。
*   **輸入驗證**: 包含檢查與確認提示，防止因輸入無效內容而導致錯誤。
*   **完整移除**: 專屬的選單選項，可完全移除排程任務與所有相關設定檔。

---

### 如何使用

#### 事前準備

在執行腳本之前，請確保您已完成以下設定：

1.  **Roon Server** 已安裝在您的 Windows 電腦上。
2.  您擁有 **ZeroTier 帳號** 並已建立虛擬網路，且擁有一組 **16 字元的 Network ID**。
3.  **ZeroTier One 客戶端** 已安裝在您的 Windows Roon Server 電腦以及您的遠端裝置（手機、筆電等）上。
4.  兩台裝置皆已 **加入 (Join)** 同一個 ZeroTier 網路。
5.  兩台裝置皆已在您的 ZeroTier Central 控制台獲得 **授權 (Authorized)**（勾選裝置旁的核取方塊）。

#### 方法 1: PowerShell (推薦)

這是最簡單且推薦的方法。

1.  右鍵點擊 Windows 開始選單，搜尋 "PowerShell" 並選擇 **Windows PowerShell (系統管理員)**。
2.  複製並貼上以下指令，然後按 Enter。腳本將自動下載並執行。

    ```powershell
    irm https://roon.evanlau1798.com | iex
    ```

3.  依照螢幕上的選單指示完成設定。

---

### 疑難排解

*   **錯誤: "Fatal Error: Could not find the ZeroTier installation"**: 請確保已安裝 ZeroTier 客戶端。腳本需要它來偵測您的網路 ID。
*   **腳本無法執行或顯示執行原則 (Execution Policy) 錯誤**: 請確保您是使用具有系統管理員權限的 PowerShell 視窗執行腳本。
