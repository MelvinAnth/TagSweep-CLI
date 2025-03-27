bash -c '
processed=0; skipped=0; failed=0;

while IFS= read -r -d "" json_file; do 
    media_file="${json_file%.json}"  # Remove .json to get media file name

    # Check for existing media files with known extensions
    for ext in jpg jpeg png mp4 mov avi mkv mp3 wav heic; do 
        if [ -f "$media_file.$ext" ]; then 
            target_file="$media_file.$ext"
            echo "🔹 Processing: $json_file → $target_file"
            
            # Apply EXIF metadata
            exiftool -overwrite_original -json="$json_file" "$target_file" 
            
            if [ $? -eq 0 ]; then 
                echo "✅ Success: $json_file → $target_file"; 
                processed=$((processed + 1)); 
            else 
                echo "❌ Failed: $json_file (ExifTool error)"; 
                failed=$((failed + 1)); 
            fi;
            break  # Stop after finding the first matching media file
        fi;
    done;

    # If no media file was found
    if [ ! -f "$target_file" ]; then 
        echo "⚠️ No Matching Media File: $json_file"; 
        skipped=$((skipped + 1)); 
    fi;

done < <(find . -type f -name "*.json" -print0);

echo ""; 
echo "✅ Processed: $processed files"; 
echo "⚠️ Skipped: $skipped files (No matching media found)"; 
echo "❌ Failed: $failed files (ExifTool errors)";
'