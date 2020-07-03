#!/usr/bin/env bash

## Shows a dropdown menu to start, stop or view the status of screensharing

case "$(echo -e " Start\n Stop\n Status" | "$HOME"/.local/bin/bemenu-run.sh -l 4 -p "Screensharing:")" in
" Start") ~/.local/bin/screenshare.sh ;;
" Stop") ~/.local/bin/screenshare.sh stop ;;
" Status") ~/.local/bin/screenshare.sh is-recording ;;
esac
