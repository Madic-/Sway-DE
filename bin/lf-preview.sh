#!/bin/sh

case "$1" in
*.tar*) tar tf "$1" ;;
*.tgz) tar tf "$1" ;;
*.zip) unzip -l "$1" ;;
*.rar) unrar l "$1" ;;
*.7z) 7z l "$1" ;;
*.pdf) pdftotext "$1" - ;;
*.docx) docx2txt "$1" - ;;
*.doc) antiword "$1" ;;
*.md) glow "$1" ;;
*) echo -e "Mime Type: $(file --mime-type $1 -b)\n---\n" && (highlight -O ansi "$1" || cat "$1") ;;
esac
