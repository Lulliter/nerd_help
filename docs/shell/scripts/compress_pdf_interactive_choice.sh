#!/bin/zsh

#!/bin/zsh

# --------------------------------------------------
# PDF compression: choose between standard/aggressive
# --------------------------------------------------
## `$` →  in shell scripting is used to reference or access a variable's value
## `:-` → sets default value if empty
## `#` → Anchors the pattern to the beginning of the string (like ^ in regex).
## `%.*` →  Removes the shortest match of the pattern from the end (gz) of the string (archive.tar.gz --> archive.tar)
## `%%.*` →  Removes the longest match of the pattern from the end (tar.gz) of the string (archive.tar.gz --> archive)
## `chmod -x ...` →  Make the script executable (it is only needed once, unless you change the script)
# --------------------------------------------------`


# 1. Ask for input directory
echo "🗂️ Enter the directory containing the PDF (default: current):"
read input_dir
input_dir="${input_dir:-.}"         # “Set input_dir to its current value if it exists, or to <.> if empty/unset.”
input_dir="${input_dir/#\~/$HOME}"  # `/#\~/$HOME`` means: if dir starts with ~, replace it with $HOME

# 2. Ask for input file name
echo "📄 Enter the PDF file name (e.g., mydoc.pdf):"
read input_file

# 3. Ask for max file size (in KB) - will not always reach desired size
echo "🔢 Enter the max allowed file size in KB (default: 500):"
read max_size_kb
max_size_kb="${max_size_kb:-500}"   # Default to 500KB if not provided

# 4. Choose compression level
echo "🛠  Choose compression level: [standard/aggressive] (default: standard)"
read compression_level
compression_level="${compression_level:-standard}"

# 5. Set paths
input_path="${input_dir%/}/$input_file" # Remove trailing slash (if present) from input_dir and append </input_file>
file_base="${input_file%.pdf}"      # Remove .pdf extension from input_file
output_path="${input_dir%/}/${file_base}_compressed.pdf"

# 6. Validate input
if [[ ! -f "$input_path" ]]; then
  echo "❌ Input PDF not found: $input_path"
  exit 1
fi

# 7. Apply Ghostscript compression
if [[ "$compression_level" == "aggressive" ]]; then
  echo "🔧 Using aggressive compression..."
  gs -sDEVICE=pdfwrite \
     -dCompatibilityLevel=1.4 \
     -dColorImageDownsampleType=/Bicubic \
     -dColorImageResolution=100 \
     -dGrayImageDownsampleType=/Bicubic \
     -dGrayImageResolution=100 \
     -dMonoImageDownsampleType=/Subsample \
     -dMonoImageResolution=150 \
     -dDownsampleColorImages=true \
     -dDownsampleGrayImages=true \
     -dDownsampleMonoImages=true \
     -dNOPAUSE -dQUIET -dBATCH \
     -sOutputFile="$output_path" "$input_path"
else
  echo "🔧 Using standard compression..."
  gs -sDEVICE=pdfwrite \
     -dCompatibilityLevel=1.4 \
     -dDownsampleMonoImages=true \
     -dMonoImageDownsampleType=/Subsample \
     -dMonoImageResolution=300 \
     -dNOPAUSE -dQUIET -dBATCH \
     -sOutputFile="$output_path" "$input_path"
fi

# 8. Confirm output
echo "✅ Compressed PDF saved to: $output_path"

# 9. Check file size
size_kb=$(du -k "$output_path" | cut -f1) # Get file size in KB (du -k) and extracts just the number (cut -f1)
if (( size_kb > max_size_kb )); then
  echo "⚠️  Warning: Compressed file is ${size_kb}KB (over desired size of ${max_size_kb}KB)"
else
  echo "✅ File size OK: ${size_kb}KB (within ${max_size_kb}KB)"
fi


# ----------------------------------------
# Usage:
# 1) Save this script as compress_pdf_interactive_choice.sh
# 2) Make it executable: chmod +x ~/scripts/compress_pdf_interactive_choice.sh
# 3) Run it: ~/scripts/compress_pdf_interactive_choice.sh
# 4) Made and alias to run it from anywhere: shrinkpdf

# /Users/luisamimmi/Documents/02_Reference/Bash_UnixShell/zshpresentation-130126150530-phpapp02.pdf