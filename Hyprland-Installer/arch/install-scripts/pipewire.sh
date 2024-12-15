#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Pipewire and Pipewire Audio Stuff #





############## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##############
# Set some colors for output messages
# Determine the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || exit 1







# Removal of pulseaudio
printf "${YELLOW}Removing pulseaudio stuff...${RESET}\n"

sudo pacman -R --noconfirm pulseaudio pulseaudio-alsa pulseaudio-bluetooth


# Disabling pulseaudio to avoid conflicts
systemctl --user disable --now pulseaudio.socket pulseaudio.service

# Pipewire
printf "${NOTE} Installing Pipewire Packages...\n"
sudo pacman -S --noconfirm  pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse

printf "Activating Pipewire Services...\n"
systemctl --user enable --now pipewire.socket pipewire-pulse.socket wireplumber.service
systemctl --user enable --now pipewire.service



