#!/bin/bash

## File preview script for the lf file manager

function FIND_OPENER() {
  echo -e "Mime Type: $(file --mime-type "$1" -b)\nDefault Opener: $(xdg-mime query default "$(xdg-mime query filetype "$1")")\n---\n"
}

case "$1" in
*.tgz | *.tar.gz) tar tf "$1" ;;
*.tar.bz2 | *.tbz2) tar tjf "$1" ;;
*.tar.txz | *.txz) xz --list "$1" ;;
*.tar) tar tf "$1" ;;
*.zip | *.jar | *.war | *.ear | *.oxt) unzip -l "$1" ;;
*.rar) unrar l "$1" ;;
*.7z) 7z l "$1" ;;
*.[1-8]) man "$1" | col -b ;;
*.o) nm "$1" | less ;;
*.iso) FIND_OPENER "$1" && iso-info --no-header -l "$1" ;;
*.odt | *.ods | *.odp | *.sxw) FIND_OPENER "$1" && odt2txt "$1" ;;
*.pdf) FIND_OPENER "$1" && pdftotext "$1" - ;;
*.docx) FIND_OPENER "$1" && docx2txt "$1" - ;;
*.doc) FIND_OPENER "$1" && antiword "$1" ;;
*.csv) cat "$1" | sed s/,/\\n/g ;;
*.md) FIND_OPENER "$1" && glow -s dark "$1" ;;
*.wav | *.mp3 | *.flac | *.m4a | *.wma | *.ape | *.ac3 | *.og[agx] | *.spx | *.opus | *.as[fx]) FIND_OPENER "$1" && exiftool "$1" ;;
*) FIND_OPENER "$1" && (highlight -O ansi "$1" || cat "$1") ;;
esac
