#!/bin/sh

if ! command -v timetagger &> /dev/null; then
  exit 1
fi

if [[ "$1" == app ]]; then
  timetagger app
  exit
fi

if [[ "$(timetagger status | sed -n -e "4p")" == "Running: N/A"* ]]; then
  echo "No time tracking"
else
  TIME=$(timetagger status | sed -n -e "4p" | awk -F ' ' '{ print $2}')
  echo " $TIME"
fi
