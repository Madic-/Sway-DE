#!/bin/sh

TIMETAGGERB=timetagger

if [[ "$1" == app ]]; then
  "$TIMETAGGERB" app
  exit
fi

if [[ "$($TIMETAGGERB status | sed -n -e "4p")" == "Running: N/A"* ]]; then
  echo "No time tracking"
else
  TIME=$($TIMETAGGERB status | sed -n -e "4p" | awk -F ' ' '{ print $2}')
  echo " $TIME"
fi
