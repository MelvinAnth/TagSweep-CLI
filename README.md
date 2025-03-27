# TagSweep CLI

**A set of command-line scripts to restore EXIF metadata from Google Takeout exports.**  

TagSweep CLI is a collection of lightweight scripts designed for those who prefer the command line over a graphical interface. It automates metadata restoration, ensuring that photos and videos exported from Google Photos retain their correct timestamps and geotags.

## **Why TagSweep CLI?**
When migrating away from Google Photos, you may notice that:
- Timestamps are incorrect.
- JSON metadata is not automatically linked to media files.
- Extra words (like "supplemental") are added to JSON filenames.
- JSON files clutter your media directories.

TagSweep CLI solves these issues with simple, efficient shell scripts.

## **Features**
- **Batch rename JSON files** for consistency.
- **Merge EXIF metadata** into media files.
- **Correct timestamps** so files are sorted properly.
- **Organize JSON files** into a separate folder for easier management.

## **Installation**
### **Clone the Repository**
```bash
git clone https://github.com/your-repo/tagsweep-cli.git
cd tagsweep-cli
chmod +x *.sh

Requirements
macOS or Linux (Windows users can run via WSL)

EXIFTool (for metadata operations)

jq (for JSON parsing)

Install dependencies using:
brew install exiftool jq  # For macOS (requires Homebrew)
sudo apt install libimage-exiftool-perl jq  # For Ubuntu/Linux

Usage
Navigate to your Takeout directory and run the appropriate script.

1. Rename JSON Files
Some Takeout exports include extra words in JSON filenames. This script renames them for consistency.

./rename_json.sh
Renames files like IMG_20240101_123456_supplemental.json → IMG_20240101_123456.json

2. Merge EXIF Metadata
This script extracts metadata from JSON and embeds it into the corresponding media file.

./merge_metadata.sh
Works for JPEG, PNG, and video files.

3. Fix File Creation & Modification Dates
Restores the correct creation and modification timestamps.

./fix_timestamps.sh
Uses EXIF data if available, otherwise retrieves timestamps from JSON.

4. Move JSON Files to a Separate Folder
Organizes JSON files into a JSON folder, keeping your media directory clean.

./organize_json.sh
Moves all .json files into JSON/ for easier management.

License & Contributions
TagSweep CLI is released under GNU General Public License v3.0. You’re free to modify and contribute.

For support, contact hello@melvin-anthony.com.