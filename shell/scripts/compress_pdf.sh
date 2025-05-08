# --------------------------------------------------
# --- Compress and copy PDF, with size limit check ---
# --------------------------------------------------

# 0) Input and target configuration
input_dir="."
input_file="Programma ROMA 25.pdf"
target_dir="."
max_size_kb=500  # ⬅️ Maximum allowed size in kilobytes

# 1) Function to compress the PDF
compress_pdf_only() {
  input_path="${input_dir%/}/$input_file"
  file_base="${input_file%.pdf}"
  output_path="${input_dir%/}/${file_base}_compressed.pdf"

  [[ -f "$input_path" ]] || {
    echo "❌ Input PDF not found: $input_path"
    return 1
  }

  gs -sDEVICE=pdfwrite \
     -dCompatibilityLevel=1.4 \
     -dDownsampleMonoImages=true \
     -dMonoImageDownsampleType=/Subsample \
     -dMonoImageResolution=300 \
     -dNOPAUSE -dQUIET -dBATCH \
     -sOutputFile="$output_path" "$input_path"

  echo "✅ Compressed PDF saved to: $output_path"

  # 2) Check file size
  size_kb=$(du -k "$output_path" | cut -f1)
  if [[ "$size_kb" -gt "$max_size_kb" ]]; then
    echo "⚠️  Warning: Compressed file is ${size_kb}KB, which exceeds the limit of ${max_size_kb}KB"
  else
    echo "✅ Compressed file size: ${size_kb}KB (within limit)"
  fi
}

# 2) Run compression
compress_pdf_only || exit 1

# 3) Copy to target folder if file exists
if [[ -f "$output_path" ]]; then
  cp "$output_path" "$target_dir/"
  echo "📁 Copied to $target_dir/"
fi

# ----------------------------------------
# Usage:
# 1) cp shell/compress_pdf.sh ~/scripts 
# 2) Make it executable: chmod +x ~/scripts/compress_pdf.sh
# 3) Run it: ~/scripts/compress_pdf.sh
 