#!/usr/bin/env bash

## Kimai Timetracking (https://www.kimai.org/) dmenu
## Requires kimai2-cmd from https://github.com/infeeeee/kimai2-cmd available as kimai2

start() {
  list_projects
  list_activities
  OUT=$(kimai2 start "$PROJECT" "$ACTIVITY")
  notify-send "$OUT"
}

stop() {
  list_active
  kimai2 stop "$ACTIVE"
  notify-send "Stopped Job $ACTIVE"
}

restart() {
  list_active
  kimai2 restart "$ACTIVE"
  notify-send "Restarted Job $ACTIVE"
}

list_projects() {
  PROJECT=$(kimai2 list-projects | $dmenu -l 30)
  #PROJECT=$(curl -X GET "$kimaiurl/api/projects" -H "accept: application/json" -H "X-AUTH-USER: $username" -H "X-AUTH-TOKEN: $password" | jq -r '.[].name' | $dmenu -l 30)
  if [ -z "$PROJECT" ]; then
    notify-send "No project selected. Exiting..."
    exit 1
  fi
}

list_activities() {
  ACTIVITY=$(kimai2 list-activities | $dmenu -l 30)
  #ACTIVITY=$(curl -X GET "$kimaiurl/api/activities" -H "accept: application/json" -H "X-AUTH-USER: $username" -H "X-AUTH-TOKEN: $password" | jq -r '.[].name' | $dmenu -l 30)
  if [ -z "$ACTIVITY" ]; then
    notify-send "No activity selected. Exiting..."
    exit 1
  fi
}

list_active() {
  ACTIVE=$(kimai2 list-active -i | $dmenu -l 3)
  ACTIVE=$(echo "$ACTIVE" | awk '{print $1}' | sed 's/[:]//g')
  #ACTIVE=$(curl -X GET "$kimaiurl/api/timesheets/active" -H "accept: application/json" -H "X-AUTH-USER: $username" -H "X-AUTH-TOKEN: $password" | jq -r '.[] | .id, .project.name' | sed -z 's/\n/ /g' | $dmenu -l 30)
  if [ -z "$ACTIVE" ]; then
    notify-send "No active task selected. Exiting..."
    exit 1
  fi
  ACTIVE=$(echo "$ACTIVE" | awk '{print $1}')
}

KIMAIRC="${XDG_CONFIG_HOME:-$HOME/.config}/kimai2/config"
if [ -f "$KIMAIRC" ]; then
  source "$KIMAIRC"
else
  echo "No config file found. This script requires a config with the following values:
kimaiurl=https://kimai.example.com
username=USER
password=API-KEY
dmenu=~/.local/bin/bemenu-run.sh
# Set to 0 if you want to ignore certificate problems
export NODE_TLS_REJECT_UNAUTHORIZED=1"
  exit 1
fi

case "$(echo -e "Start\nStop\nRestart\n" | $dmenu -l 3 -p "Kimai:")" in
"Start") start ;;
"Stop") stop ;;
"Restart") restart ;;
esac
