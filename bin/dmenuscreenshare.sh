#!/usr/bin/env bash

## Shows a dropdown menu to start, stop or view the status of screensharing

case "$(echo -e " Start\n Stop\n Status" | bemenu-run.sh -l 4 -p "Screensharing:")" in
" Start") screenshare.sh ;;
" Stop") screenshare.sh stop ;;
" Status") screenshare.sh is-recording ;;
esac
