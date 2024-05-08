#!/usr/bin/env bash
device_toggle() {
  # $(pactl list sinks) to find sinks
  if [[ -z "$(pactl get-default-sink | grep 'analog')" ]]; then
    pactl set-default-sink alsa_output.pci-0000_2d_00.4.analog-stereo
  else
    pactl set-default-sink alsa_output.pci-0000_2b_00.1.hdmi-stereo-extra3
  fi
  
}
analog_device_running() {
    if [[ -z "$(pactl get-default-sink | grep 'analog')" ]]; then
      echo "true"
    else
      echo "false"
    fi
}
listen_device() {
  analog_device_running

  while read line; do
    analog_device_running
  done < <(pactl subscribe | grep --line-buffered "'change' on server")
}
# Get Volume
get_volume() {
  echo "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -n 1)"
  while read line; do
    echo "$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -n 1)"
  done < <(pactl subscribe | grep --line-buffered "'change' on sink")
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
if [[ "$1" == "volume" ]]; then
  if [[ "$2" == "--get" ]]; then
  	get_volume
  elif [[ "$2" == "--set" ]]; then
    set_volume $3
  elif [[ "$2" == "--inc" ]]; then
  	inc_volume
  elif [[ "$2" == "--dec" ]]; then
  	dec_volume
  elif [[ "$2" == "--toggle" ]]; then
  	toggle_mute
  else
  	get_volume
  fi
elif [[ "$1" == "device" ]]; then
  if [[ "$2" == "--listen" ]]; then
    listen_device
  elif [[ "$2" == "--toggle" ]]; then
    device_toggle
  fi
else
 echo "sound.sh <command> [<args>]"
 echo "Usage:"
 echo " volume"
 echo "  --get    | listens to the current volume for the default sink"
 echo "  --set    | sets the volume for the default sink"
 echo "  --inc    | increases the volume by 5%"
 echo "  --dec    | decreases the volume by 5%"
 echo "  --toggle | toggles mute"
 echo " device"
 echo "  --listen | listen to sink changes"
 echo "  --toggle | toggles the default sink"
 echo ""
fi
