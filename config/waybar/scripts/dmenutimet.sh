#!/usr/bin/env bash

TIMETAGGERB=timetagger

case "$(echo -e " Start\n Stop\n" | bemenu-run.sh -l 2 -p "Timetracking:")" in
" Start") $TIMETAGGERB start "INFONLINE #Work" ;;
" Stop") $TIMETAGGERB stop ;;
esac
