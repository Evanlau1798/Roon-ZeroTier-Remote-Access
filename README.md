# Roon + ZeroTier Automation Management Tool

[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)](https://docs.microsoft.com/en-us/powershell/) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Status](https://img.shields.io/badge/status-working-brightgreen)](https://github.com/evanlau1798/Roon-ZeroTier-Remote-Access)

A powerful, menu-driven PowerShell script to automate the remote access setup for Roon Server on Windows using ZeroTier.

This tool solves the common problem where Roon clients on an external network cannot discover the Roon Server because the ZeroTier virtual network adapter is treated as a "Public" network by Windows. The script provides a secure, persistent, and user-friendly way to manage this automation.

---

### Features

* **One-Liner Execution**: Simple, no-fuss execution directly in PowerShell.
* **Menu-Driven Interface**: An easy-to-use menu to install, edit, and uninstall the automation.
* **Network ID Specific**: The script targets a *specific* ZeroTier Network ID, ensuring other ZeroTier connections remain secure and untouched.
* **Intelligent Network Detection**: Automatically detects active ZeroTier networks to make selection easy and error-free.
* **Color-Coded Display**: Active networks are displayed with colors for names and IDs for enhanced readability.
* **Input Validation**: Includes checks and confirmation prompts to prevent errors from invalid input.
* **Full Uninstall**: A dedicated menu option to completely remove the scheduled task and all related configuration files.

---

### How to Use

#### Prerequisites

Before running the script, please ensure you have completed the following setup:
1.  **Roon Server** is installed on your Windows PC.
2.  You have a **ZeroTier account** and have created a virtual network, which gives you a **16-character Network ID**.
3.  The **ZeroTier One client** is installed on both your Windows Roon Server PC and your remote device (phone, laptop, etc.).
4.  Both devices have **joined** the same ZeroTier network.
5.  Both devices have been **authorized** in your ZeroTier Central dashboard (the checkbox next to them is ticked).

#### Method 1: PowerShell (Recommended)

This is the simplest and recommended method.

1.  Right-click the Windows Start menu, search "PowerShell" and select **Windows PowerShell (Admin)**.
2.  Copy and paste the following command, then press Enter. The script will be downloaded and executed automatically.

    ```powershell
    irm https://roon.evanlau1798.com | iex
    ```

3.  Follow the on-screen menu to complete the setup.

---

### Troubleshooting

* **Error: "ZeroTier CLI not found"**: Ensure the ZeroTier client is installed. The script needs this to detect your network IDs.
* **The script doesn't run or shows an error about Execution Policy (Manual Method)**: Ensure you are running the script from a PowerShell window with administrative privileges.