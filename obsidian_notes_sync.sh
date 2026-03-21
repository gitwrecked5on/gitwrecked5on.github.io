#!/bin/bash
# sync.sh
# Reads the correct 'obsidian-vault/websitenotesfolder' path for this machine from obsidian_notes_path.config,
# then syncs websitenotesfolder → content/ before a push.
# Run this whenever you want to publish Obsidian changes to the website.

# ── 1. Find this machine's hostname ──────────────────────────────────────────
HOSTNAME=$(hostname)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"  # directory where sync.sh lives
PATHS_CONFIG="$SCRIPT_DIR/obsidian_notes_path.config"
CONTENT_DIR="$SCRIPT_DIR/content"

# ── 2. Look up this machine's vault path in obsidian_notes_path.config ───────
# Skips lines starting with # (comments) and empty lines
SOURCE_PATH=""
while IFS='|' read -r host path; do
  [[ "$host" =~ ^#.*$ || -z "$host" ]] && continue  # skip comments/blanks
  if [[ "$host" == "$HOSTNAME" ]]; then
    SOURCE_PATH="$path"
    break
  fi
done < "$PATHS_CONFIG"

# ── 3. Bail out if no matching entry found ────────────────────────────────────
if [[ -z "$SOURCE_PATH" ]]; then
  echo "ERROR: No entry found for hostname '$HOSTNAME' in obsidian_notes_path.config"
  echo "Add a line like:  $HOSTNAME|/path/to/your/ChaosGarden"
  exit 1
fi

# ── 4. Rsync ChaosGarden → content/ ──────────────────────────────────────────
# --delete ensures files removed in Obsidian also disappear from content/
# --exclude stops Obsidian internal folders from leaking into the site
echo "Syncing from: $SOURCE_PATH"
echo "Syncing to:   $CONTENT_DIR"
rsync -av --delete \
  --exclude='.obsidian/' \
  --exclude='.trash/' \
  "$SOURCE_PATH/" "$CONTENT_DIR/"

# ── 5. Stage content/ in git ──────────────────────────────────────────────────
# Quartz uses git to track file dates — untracked files get date warnings
# This ensures every synced file is git-tracked after each sync
git add content/

echo "Sync complete."