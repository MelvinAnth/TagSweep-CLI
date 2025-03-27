bash -c '
TARGET_DIR="./JSON"

# Create the target directory if it doesn'\''t exist
mkdir -p "$TARGET_DIR"

# Find and move all .json files
find . -type f -iname "*.json" -exec mv {} "$TARGET_DIR" \;

echo "✅ All JSON files have been moved to $TARGET_DIR."
'