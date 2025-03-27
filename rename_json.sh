bash -c '
renamed=0; ignored=0; renamed_files=(); ignored_files=();
while IFS= read -r -d "" f; do 
    dir=$(dirname "$f")  # Extract directory of the file
    filename=$(basename "$f")  # Extract filename
    base="${filename%%.*}"  # Extract base name before the first dot
    matched=false; 
    for ext in jpg jpeg png mp4 mov avi mkv mp3 wav heic; do 
        if [ -f "$dir/$base.$ext" ]; then 
            new_name="$dir/$base.json"  # Keep file inside its directory
            mv "$f" "$new_name"; 
            renamed_files+=("$f → $new_name"); 
            renamed=$((renamed + 1)); 
            matched=true; 
            break; 
        fi; 
    done; 
    if [ "$matched" = false ]; then 
        ignored_files+=("$f"); 
        ignored=$((ignored + 1)); 
    fi; 
done < <(find . -type f -name "*.json" -print0); 

echo "✅ Renamed $renamed file(s):"; 
for file in "${renamed_files[@]}"; do 
    echo "  - $file"; 
done; 

echo ""; 
echo "⚠️ Ignored $ignored file(s) (No matching media file found):"; 
for file in "${ignored_files[@]}"; do 
    echo "  - $file"; 
done'