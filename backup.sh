#!/bin/bash

# === Backup Configuration ===
CONFIG_FILE="./backup.config"
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: Configuration file '$CONFIG_FILE' not found!"
    exit 1
fi

source "$CONFIG_FILE"

# === Log Function ===
log() {
    local level="$1"
    local message="$2"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $level: $message" | tee -a "$LOG_FILE"
}

# === Restore Function ===
restore_backup() {
    local backup_file="$1"

    if [ -z "$backup_file" ]; then
        echo "Usage: $0 restore <backup_filename>"
        exit 1
    fi

    if [ ! -f "$BACKUP_DIR/$backup_file" ]; then
        log "ERROR" "Backup file '$backup_file' not found in $BACKUP_DIR"
        exit 1
    fi

    log "INFO" "Restoring from backup: $backup_file"
    tar -xzf "$BACKUP_DIR/$backup_file" -C .
    log "SUCCESS" "Backup '$backup_file' restored successfully to current directory."
    exit 0
}

# === Handle Restore Command ===
if [ "$1" == "restore" ]; then
    restore_backup "$2"
fi

# === Backup Process ===
SOURCE_DIR="$1"

if [ -z "$SOURCE_DIR" ]; then
    echo "Usage: $0 <source_directory>"
    echo "Or:    $0 restore <backup_filename>"
    exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
    log "ERROR" "Source directory '$SOURCE_DIR' not found!"
    exit 1
fi

mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

TIMESTAMP=$(date +%Y-%m-%d-%H%M%S)
BACKUP_FILE="$BACKUP_DIR/backup-$TIMESTAMP.tar.gz"
CHECKSUM_FILE="$BACKUP_FILE.sha256"

log "INFO" "Starting backup of $SOURCE_DIR"

# Create backup
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"
if [ $? -eq 0 ]; then
    log "SUCCESS" "Backup created: $BACKUP_FILE"
else
    log "ERROR" "Backup creation failed!"
    exit 1
fi

# Create checksum
sha256sum "$BACKUP_FILE" > "$CHECKSUM_FILE"
log "INFO" "Checksum file created."

# Verify checksum
sha256sum -c "$CHECKSUM_FILE" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    log "SUCCESS" "Checksum verified successfully."
else
    log "ERROR" "Checksum verification failed!"
    exit 1
fi

# === Rotation Policy ===
log "INFO" "Applying rotation policy..."
BACKUP_COUNT=$(ls "$BACKUP_DIR"/backup-*.tar.gz 2>/dev/null | wc -l)

if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
    OLDEST=$(ls -t "$BACKUP_DIR"/backup-*.tar.gz | tail -1)
    rm -f "$OLDEST" "$OLDEST.sha256"
    log "INFO" "Deleted oldest backup: $OLDEST"
fi

log "SUCCESS" "Backup process completed successfully!"
