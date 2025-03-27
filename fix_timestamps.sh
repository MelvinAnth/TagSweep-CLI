bash -c '
processed=0; failed=0; json_used=0;

while IFS= read -r -d "" media_file; do 
    echo "🔹 Processing: $media_file"

    dir=$(dirname "$media_file")  # Get directory of media file
    filename=$(basename "$media_file")  # Extract filename with extension
    base="${filename%.*}"  # Get filename without extension
    json_file="$dir/$base.json"  # Expected JSON file path

    # Check if DateTimeOriginal exists in metadata
    datetime_original=$(exiftool -s -s -s -DateTimeOriginal "$media_file" 2>/dev/null)

    if [ -z "$datetime_original" ]; then
        echo "⚠️ Warning: No DateTimeOriginal found in metadata → Checking JSON: $json_file"
        
        if [ -f "$json_file" ]; then
            # Extract timestamp from JSON
            timestamp=$(jq -r ".photoTakenTime.timestamp" "$json_file" 2>/dev/null)

            if [[ "$timestamp" =~ ^[0-9]+$ ]]; then
                # Convert UNIX timestamp to EXIF-compatible format
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    formatted_date=$(date -u -r "$timestamp" +"%Y:%m:%d %H:%M:%S")  # macOS
                else
                    formatted_date=$(date -u -d @"$timestamp" +"%Y:%m:%d %H:%M:%S")  # Linux
                fi

                echo "📝 Found DateTimeOriginal in JSON: $formatted_date → Applying to $media_file"

                # Apply extracted timestamp to media file
                exiftool "-DateTimeOriginal=$formatted_date" "-FileCreateDate=$formatted_date" "-FileModifyDate=$formatted_date" -overwrite_original "$media_file"

                if [ $? -eq 0 ]; then 
                    echo "✅ Success (JSON used): $media_file"; 
                    json_used=$((json_used + 1)); 
                    processed=$((processed + 1)); 
                else 
                    echo "❌ Failed (ExifTool error): $media_file"; 
                    failed=$((failed + 1)); 
                fi;
            else
                echo "❌ Failed: No valid timestamp in JSON → Skipping: $media_file"
                failed=$((failed + 1))
            fi
        else
            echo "❌ Failed: No matching JSON file → Skipping: $media_file"
            failed=$((failed + 1))
        fi
    else
        # Apply existing DateTimeOriginal to FileCreateDate and FileModifyDate
        exiftool "-FileCreateDate<DateTimeOriginal" "-FileModifyDate<DateTimeOriginal" -overwrite_original "$media_file"

        if [ $? -eq 0 ]; then 
            echo "✅ Success (EXIF metadata used): $media_file"; 
            processed=$((processed + 1)); 
        else 
            echo "❌ Failed (ExifTool error): $media_file"; 
            failed=$((failed + 1)); 
        fi;
    fi

done < <(find . -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.mp4" -o -iname "*.mov" -o -iname "*.avi" -o -iname "*.mkv" -o -iname "*.mp3" -o -iname "*.wav" -o -iname "*.heic" \) -print0);

echo ""; 
echo "✅ Processed: $processed files"; 
echo "✅ Used JSON metadata: $json_used files"; 
echo "❌ Failed: $failed files (Missing DateTimeOriginal or JSON errors)";
'