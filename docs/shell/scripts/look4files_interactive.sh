#!/bin/zsh

# Interactive search script (Zsh compatible)

# Ask user for the search string
echo "🔍 Enter the string to search for (quotes optional unless using spaces):"
read search_string

# Ask for directory (default to current)
echo "📂 Enter the directory to search in (default: current):"
read directory
directory=${directory:-.}
directory="${directory/#\~/$HOME}"

# Ask for extensions (default set)
echo "🧾 Enter space-separated file extensions to include (default: pdf docx doc md R qmd):"
read exts_input
extensions=(${(z)exts_input:-pdf docx doc md R qmd})

echo "\n🔎 Searching for '$search_string' in '$directory' among: ${extensions[*]}\n"

# R/qmd/md — grep directly
find "$directory" \( -iname "*.R" -o -iname "*.qmd" -o -iname "*.md" \) -type f -exec grep -El --ignore-case "$search_string" {} +

# PDF
find "$directory" -type f -name "*.pdf" -exec sh -c '
  for file do
    if pdftotext "$file" - 2>/dev/null | grep -qiE "$0"; then
      echo "$file"
    fi
  done
' "$search_string" sh {} +

# DOCX
find "$directory" -type f -name "*.docx" -exec sh -c '
  for file do
    if pandoc "$file" -t plain 2>/dev/null | grep -qiE "$0"; then
      echo "$file"
    fi
  done
' "$search_string" sh {} +

# DOC
find "$directory" -type f -name "*.doc" -exec sh -c '
  for file do
    if antiword "$file" 2>/dev/null | grep -qiE "$0"; then
      echo "$file"
    fi
  done
' "$search_string" sh {} +


# to call it 
# ~/scripts/look4files_interactive.sh
