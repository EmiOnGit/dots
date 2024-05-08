#!/usr/bin/env bash

# path of the dot directory
src=$(dirname "$(realpath "$0")")

if [[ -z "${XDG_CONFIG_HOME}" ]]; then
  conf_out="${HOME}/.config"
else
  conf_out="${XDG_CONFIG_HOME}"
fi
if [[ -z "${XDG_DATA_HOME}" ]]; then
  data_out="${HOME}/.local/share"
else
  data_out="${XDG_DATA_HOME}"
fi

#### Takes the directory as input which should be removed
function try_remove {
  # -L tests whether there is a symlink
  if [[ -L $1 ]]; then
    rm -rf $1
  # -e tests where there is a file.
  elif [[ -e $1 ]]; then
    # If the directory is not already a link we might override existing files.
    # For safety reasons the user has to remove it by hand.
    echo "$1 has to be removed for this script to continue"
    exit
  fi
}
function ln_conf {
  local out=$conf_out/$1
  try_remove "$out"
  #### Place new config links
  ln -sf $src/$1 $out
}
function ln_data {
  local out=$data_out/$1
  try_remove "$out"
  #### Place new config links
  ln -sf $src/$1 $out
}

# DATA
ln_data "themes"
# CONFIGS
ln_conf "helix"
ln_conf "hypr"
ln_conf "fontconfig"
ln_conf "kitty"
ln_conf "nushell"
ln_conf "fish"
ln_conf "eww"
