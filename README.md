Automated Backup System (Bash Scripting Project)
A. Project Overview

This project is an Automated Backup System written in Bash.
It allows you to back up folders, verify backups, restore data, delete old backups, and keep everything organized using a configuration file.

It is useful because:

It prevents data loss

Automates daily backup tasks

Ensures backup integrity using checksums

Saves disk space with smart rotation

Keeps logs for debugging and auditing

Offers restore functionality

B. How to Use the Backup System
1. Installation

Clone or download your project folder:

backup-system/
├── backup.sh
├── backup.config
└── README.md


Make the script executable:

chmod +x backup.sh


Edit backup.config to suit your system.

2. Configuration File – backup.config

Example:

BACKUP_DIR=/home/user/backups
LOG_FILE=/home/user/backups/backup.log
MAX_BACKUPS=5

What each setting means:

BACKUP_DIR → Where backups will be saved

LOG_FILE → Where logs will be written

MAX_BACKUPS → Maximum number of backups to keep (old ones automatically deleted)

3. Basic Usage
Create a Backup
./backup.sh /path/to/folder


Example:

./backup.sh /home/user/documents


This will:

Create a compressed .tar.gz backup

Create a .sha256 checksum

Verify the backup

Save log entries

Apply rotation rules

Restore a Backup
./backup.sh restore backup-YYYY-MM-DD-HHMMSS.tar.gz


Backup will be restored into the current directory.

C. How the Script Works
1. Backup Creation

When you provide a folder path:

Script loads configuration

Checks if the folder exists

Creates backup folder & log folder

Generates timestamp (YYYY-MM-DD-HHMMSS)

Creates a backup file:

backup-2025-02-15-103020.tar.gz


Logs success or failure

2. Checksum Process

Checksum ensures file integrity.

Steps:

Creates SHA256 checksum:

backup-2025-02-15-103020.tar.gz.sha256


Immediately verifies it

Logs whether verification passed or failed

This ensures the backup is not corrupted.

3. Rotation Algorithm (Deleting Old Backups)

The script:

Counts total .tar.gz files inside BACKUP_DIR

If count > MAX_BACKUPS:

Sorts backups by date

Deletes oldest backup

Deletes the checksum for that backup

This prevents unlimited storage usage.

4. Restore Logic

When you run:

./backup.sh restore <backup-file>


The script:

Checks if the backup exists

Extracts it in the current directory

Logs success

5. Logging System

Every action goes to the log file:

Example:

[2025-02-13 10:45:20] INFO: Starting backup
[2025-02-13 10:45:21] SUCCESS: Backup created
[2025-02-13 10:45:23] SUCCESS: Checksum verified
[2025-02-13 10:45:23] INFO: Deleted old backup


Logs help track:

Success events

Errors

Backup failures

Rotation actions

D. Design Decisions
1. Timestamp Naming

Using YYYY-MM-DD-HHMMSS ensures:

Unique backup names

Easy sorting

Clean rotation

2. SHA256 Instead of MD5

SHA256 is more secure and standard.

3. Using Config File

This avoids hardcoding values in script.
Users can change:

Path

Max backups

Log location

4. Simple Rotation Mechanism

Instead of complicated daily/weekly/monthly backups, this script:

Keeps a maximum number

Deletes only the oldest
(Simpler and reliable for beginners)

5. Function-Based Code

The script is split into:

restore_backup

backup logic

rotation logic

logging function

This improves readability and maintainability.

E. Testing

Below are the recommended test cases.

1. Successful Backup Test
./backup.sh testfolder


Expected:

Backup file created

Checksum generated

Log entries written

2. Restore Test
./backup.sh restore backup-2025-02-15-103020.tar.gz


Expected:

Extracted files

Log entry: restore successful

3. Rotation Test

Set:

MAX_BACKUPS=2


Create 3 backups:

./backup.sh folder
./backup.sh folder
./backup.sh folder


Expected:

1st backup deleted automatically

4. Error Tests

❌ Non-existent folder:

./backup.sh /wrong/path


❌ Missing config:

rm backup.config
./backup.sh folder


All should show readable error messages.

F. Known Limitations

This script does NOT currently support:

❌ Daily / Weekly / Monthly rotation
❌ Excluding files (like .git or node_modules)
❌ Dry-run mode
❌ Lock file to prevent multiple runs
❌ Email notifications
❌ Incremental backups

These can be added in future improvements.

G. Example Run Outputs
Backup Creation
[2025-02-15 10:30:20] INFO: Starting backup of testfolder
[2025-02-15 10:30:21] SUCCESS: Backup created: backup-2025-02-15-103021.tar.gz
[2025-02-15 10:30:21] INFO: Checksum created.
[2025-02-15 10:30:22] SUCCESS: Checksum verified.

Restore Example
[2025-02-15 10:45:10] INFO: Restoring from backup file
[2025-02-15 10:45:12] SUCCESS: Restore completed.

H. Conclusion

This project demonstrates:

Bash scripting skills

File handling

Logging

Backup verification

Restoration process

Rotation policy

It fulfills the core backup requirements and can be extended with advanced features later.
