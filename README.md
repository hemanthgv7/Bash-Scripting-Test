# Bash-Scripting-Test

A simple and powerful Bash script to automatically back up files or directories, verify integrity, and manage old backups using a rotation policy.

---

## 🚀 Features

- 📦 Creates compressed `.tar.gz` backups  
- 🔐 Verifies backup integrity using checksum (SHA256)  
- 🔁 Automatically deletes old backups based on rotation policy  
- 🪵 Logs every backup activity with timestamps  
- ⚙️ Fully configurable via `backup.config`

---

## 🧩 Project Structure

bash-scripting/
├── backup.sh # Main backup script
├── backup.config # Configuration file
├── testdata/ # Example folder to back up
└── backups/ # Generated backups stored here


🧠 How It Works

1.Reads configuration from backup.config

2.Creates a timestamped backup (e.g., backup-2025-11-05-162912.tar.gz)

3.Generates a SHA256 checksum file for verification

4.Validates integrity of the backup

5.Removes older backups when limit (MAX_BACKUPS) is exceeded

6.Logs all events with timestamps in backup.log
