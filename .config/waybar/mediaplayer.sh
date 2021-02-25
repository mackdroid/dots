#!/bin/sh
player_status_spot=$(playerctl -p spotify status 2> /dev/null)
player_status=$(playerctl status 2> /dev/null)
  if [ "$player_status_spot" = "Playing" ]; then
      echo "  $(playerctl -p spotify metadata artist) - $(playerctl -p spotify metadata title)"
  elif [ "$player_status_spot" = "Paused" ]; then
      echo " $(playerctl -p spotify metadata artist) - $(playerctl -p spotify metadata title)"
  elif [ "$player_status" = "Playing" ]; then
      echo "  $(playerctl metadata artist) - $(playerctl metadata title)"
  elif [ "$player_status" = "Paused" ]; then
      echo " $(playerctl metadata artist) - $(playerctl metadata title)"
  else
  echo " "
  fi
