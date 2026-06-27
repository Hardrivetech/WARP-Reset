# WARP-Reset 🚀

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
*See the [LICENSE](LICENSE) file for more information.*

A robust, production-ready PowerShell utility designed to manage the Cloudflare WARP service. This script handles service lifecycle, IP tracking, and logging, providing a seamless way to force an IP rotation for the WARP tunnel.

## 📋 Features

* **Automated Service Management:** Safely stops and restarts the Cloudflare WARP service with verification loops to prevent "orphan" service states.
* **IP Monitoring:** Automatically fetches and logs your public IP before and after the reset to track connectivity changes.
* **Persistent Logging:** Maintains a detailed history of operations in `warp_reset.log` and a chronological list of assigned IPs in `IPLog.txt`.
* **State Awareness:** Displays the timestamp of the last successful reset directly in the console for quick reference.
* **Production-Ready:** Includes comprehensive error handling, input validation, and environment setup.

---

## 🛠️ Installation

1.  **Download the Script:**
    * Create a directory at `C:\WARP-Reset\`.
    * Save the `warp_Reset.ps1` script into this folder.

2.  **Create the Shortcut:**
    * Right-click your desktop > **New** > **Shortcut**.
    * In the location box, paste the following command:
        `powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\WARP-Reset\warp_Reset.ps1"`
    * Name the shortcut "Restart WARP".

3.  **Configure Permissions:**
    * Right-click the new shortcut > **Properties**.
    * Go to the **Shortcut** tab > **Advanced...**.
    * Check **Run as administrator** and click **OK**.

4.  **Add Icon (Optional):**
    * In the Shortcut Properties > **Change Icon...**, select the icon file provided in your `/assets` folder.

5.  **Pin to Taskbar:**
    * Right-click the shortcut and select **Pin to taskbar**.

---

## 📂 Project Structure

```text
C:\WARP-Reset\
├── warp_Reset.ps1     # The primary automation script
├── assets/
│   └── warp_icon.ico  # Custom application icon
└── Logs/              # Created automatically on first run
    ├── warp_reset.log # Full operation history
    ├── IPLog.txt      # Chronological list of IPs used
    └── LastRun.txt    # Timestamp of the latest successful reset
```
---

## 💡 Troubleshooting

  Script doesn't run: Ensure your execution policy allows running local scripts. The shortcut provided uses -ExecutionPolicy Bypass to handle this securely.

  Logs are empty: Verify the script has permission to write to the C:\WARP-Reset\ directory.

  IP not changing: Cloudflare’s network is designed for high availability. If you receive the same IP, it is because you are being re-routed to the same optimized gateway. This is standard behavior for the WARP client.

## ⚖️ License

This project is licensed under the MIT License. See the [License](LICENSE) file for full details.

Built for reliability and transparency.
