#!/usr/bin/env bash

## Creates screenshots
## Modded from https://gitlab.com/racy/swayshot/blob/master/swayshotgc

if [[ -z $WAYLAND_DISPLAY ]]; then
  (echo >&2 Wayland is not running)
  exit 1
fi

SCREENSHOTS_FOLDER=$(xdg-user-dir PICTURES)/screenshots

if [[ ! -d $SCREENSHOTS_FOLDER ]]; then
  mkdir -p $SCREENSHOTS_FOLDER
fi

SCREENSHOT_FILENAME=$SCREENSHOTS_FOLDER/screenshot-$(date +'%Y-%m-%d-%H%M%S').png

declare -r filter='
# returns the focused node by recursively traversing the node tree
def find_focused_node:
    if .focused then .
	else (
			if .nodes then (.nodes | .[] | find_focused_node)
			else empty
			end
		)
	end;
# returns a string in the format that grim expects
def format_rect:
    "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)";
find_focused_node | format_rect
'

# ppm/png/jpg
CAPTURE_FORMAT=png

case "$1" in
foobar)
  $(swaymsg --type get_tree --raw | jq --raw-output "${filter}")
  ;;

region)
  grim -t ${CAPTURE_FORMAT} -g "$(slurp -b '#AFAFAFAF' -c '#FF4F3FAF' -s '#00000000' -w 3 -d)" "$SCREENSHOT_FILENAME" && wl-copy <$SCREENSHOT_FILENAME
  notify-send "Region screenshot saved at ${SCREENSHOT_FILENAME} and copied to clipboard"
  echo -n ${SCREENSHOT_FILENAME}
  ;;

window)
  grim -t ${CAPTURE_FORMAT} -g "$(swaymsg --type get_tree --raw | jq --raw-output "${filter}")" "$SCREENSHOT_FILENAME" && wl-copy <$SCREENSHOT_FILENAME
  notify-send "Active window screenshot saved at ${SCREENSHOT_FILENAME} and copied to clipboard"
  echo -n ${SCREENSHOT_FILENAME}
  ;;

display)
  grim -t ${CAPTURE_FORMAT} -o "$(swaymsg --type get_outputs --raw | jq --raw-output '.[] | select(.focused) | .name')" "$SCREENSHOT_FILENAME" && wl-copy <$SCREENSHOT_FILENAME
  notify-send "Active display screenshot saved at ${SCREENSHOT_FILENAME} and copied to clipboard"
  echo -n ${SCREENSHOT_FILENAME}
  ;;

all)
  grim -t ${CAPTURE_FORMAT} "$SCREENSHOT_FILENAME" && wl-copy <$SCREENSHOT_FILENAME
  notify-send "Whole screen screenshot saved at ${SCREENSHOT_FILENAME} and copied to clipboard"
  echo -n ${SCREENSHOT_FILENAME}
  ;;

\
  *)
  echo 'Usage: screenshots [all-to-file|all-to-clipboard|active-display-to-clipboard|active-display-to-file|window-to-file|window-to-clipboard|region-to-file|region-to-clipboard]'
  exit 0
  ;;
esac
