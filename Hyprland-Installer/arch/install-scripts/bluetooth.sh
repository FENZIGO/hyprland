#!/bin/bash


blue=(
"bluez"
"bluez-utils"
"blueman"
"gnome-bluetooth-3.0"
)

## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1

install_package() {
  if yay -Q "$1" &> /dev/null; then
    echo -e "${OK} $1 is already installed. Skipping..."
  else
    echo -e "${NOTE} Installing $1 ..."
    yay -S --noconfirm "$1"
    if yay -Q "$1" &> /dev/null; then
      echo -e "${OK} $1 was installed."
    else
      echo -e "${ERROR} $1 failed to install. Please check the install.log."
      exit 1
    fi
  fi
}

sudo systemctl enable --now bluetooth.service 


