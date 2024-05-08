#!/usr/bin/env bash

while read line; do
  if [[ -z "$(pactl get-default-sink | grep 'analog')" ]]; then
    echo "true"
  else
    echo "false"
  fi
done < <(pactl subscribe | grep --line-buffered "'change' on server")
