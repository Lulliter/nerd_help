#!/bin/bash
# ------- LOOK4FILES ------- #
# This script searches for a specific string in various file types (PDF, DOCX, DOC, MD, TXT) within a specified directory.
# It returns the full paths of files containing the string.


# --- INPUT VARIABLES ---
search_string="$1"                      # e.g. "sviluppo sostenibile"
directory="${2:-.}"                     # default to current directory
extensions=("R" "qmd" "md" "pdf" "docx" "doc")  # Add/remove as needed

# --- R/QMD/MD: Text files (handled directly by grep) ---
find "$directory" \( -name "*.R" -o -name "*.qmd" -o -name "*.md" \) -type f -exec grep -El --ignore-case "$search_string" {} +

# --- PDF ---
find "$directory" -type f -name "*.pdf" -exec sh -c '
  for file do
    if pdftotext "$file" - 2>/dev/null | grep -qiE "$0"; then
      echo "$file"
    fi
  done
' "$search_string" sh {} +

# --- DOCX ---
find "$directory" -type f -name "*.docx" -exec sh -c '
  for file do
    if pandoc "$file" -t plain 2>/dev/null | grep -qiE "$0"; then
      echo "$file"
    fi
  done
' "$search_string" sh {} +

# --- DOC ---
find "$directory" -type f -name "*.doc" -exec sh -c '
  for file do
    if antiword "$file" 2>/dev/null | grep -qiE "$0"; then
      echo "$file"
    fi
  done
' "$search_string" sh {} +


# ------- HOW TO USE ------- #
# 1. Save the script as `look4files.sh` in/as `~/scripts/look4files.sh` ✅
# 2. Make it executable: `chmod +x look4files.sh`✅
# 3. Run it as: `~/scripts/look4files.sh "search_string" "/path/to/directory"`
#    - If no directory is specified, it defaults to the current directory.  
#    - The script will output the paths of files containing the search string.

# 4.a ALSO, to make it available globally, you can add the following line to your `.bash_profile` or `.zshrc`:
#    ```bash
#    open ~/.zshrc
#    export PATH="$HOME/scripts:$PATH"
#    source ~/.zshrc
#    ```
# 4.b NOW, you can run it from anywhere in the terminal using:
#    ```bash
#    look4files.sh "search_string" "/path/to/directory"
# or maybe better (no " " in the path):
#     look4files.sh "search_string" /path/to/directory
#    ```
