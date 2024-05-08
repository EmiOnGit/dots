#!/bin/env bash

# Get Volume
get_volume() {
	
	muted=`pactl get-sink-mute @DEFAULT_SINK@ | grep "no"`
	if [[ -z "$muted" ]]; then
		echo "-"
		exit
	fi 
	volume=`pactl get-sink-volume @DEFAULT_SINK@ | grep -Eo [0-9]\?[0-9]\?[0-9]\% | head -n1 | sed 's/[^0-9]*//g'`

	if [[ "$volume" == "0" ]]; then
		echo "-"
	else
		echo "$volume"
	fi
}


# Increase Volume
inc_volume() {
	vol="$(get_volume)"
	current="${vol%%%}"

	if [[ "$current" -eq "0" ]]; then
		toggle_mute
	fi

	pactl set-sink-volume @DEFAULT_SINK@ +5%
}

# Decrease Volume
dec_volume() {
	vol="$(get_volume)"
	current="${vol%%%}"

	if [[ "$current" -eq "0" ]] 
	then
		toggle_mute
	fi

	pactl set-sink-volume @DEFAULT_SINK@ -5%
}

# Toggle Mute
toggle_mute() {
	pactl set-sink-mute @DEFAULT_SINK@ toggle
}
set_volume() {
  echo $1
  pactl set-sink-volume @DEFAULT_SINK@ "$1"
}
# Execute accordingly
if [[ "$1" == "--get" ]]; then
	get_volume
elif [[ "$1" == "--set" ]]; then
  set_volume $2
elif [[ "$1" == "--inc" ]]; then
	inc_volume
elif [[ "$1" == "--dec" ]]; then
	dec_volume
elif [[ "$1" == "--toggle" ]]; then
	toggle_mute
else
	get_volume
fi
