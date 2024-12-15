#!/bin/bash

script_directory=install-scripts
 # Function to execute a script if it exists and make it executable
execute_script() {
    local script="$1"
    local script_path="$script_directory/$script"
    if [ -f "$script_path" ]; then
        chmod +x "$script_path"
        if [ -x "$script_path" ]; then
            env USE_PRESET=$use_preset  "$script_path"
        else
            echo "Failed to make script '$script' executable."
        fi
    else
        echo "Script '$script' not found in '$script_directory'."
    fi
}

chmod +x install-scripts/*
sleep 0.5

# Install yay
execute_script "yay.sh"

# Install cachy repo
execute_script "cachy-repo.sh"

# Install hyprland packages
execute_script "00-hypr-pkgs.sh"

# Install pipewire and pipewire-audio
execute_script "pipewire.sh"


#execute_script "InputGroup.sh"

# Load default config example from github 
execute_script "default_config.sh"



#if [ "$gtk_themes" == "Y" ]; then
 #   execute_script "gtk_themes.sh"
#fi

if [ "$bluetooth" == "Y" ]; then
    execute_script "bluetooth.sh"
fi

#if [ "$sddm" == "Y" ]; then
#    execute_script "sddm.sh"
#fi

if [ "$xdph" == "Y" ]; then
    execute_script "xdph.sh"
fi

#if [ "$zsh" == "Y" ]; then
#    execute_script "zsh.sh"
#fi






#if [ "$dots" == "Y" ]; then
#    execute_script "dotfiles.sh"

#fi


printf "Installation Completed.\n"
printf "\n"
sleep 2
printf "You can start Hyprland by typing Hyprland (IF SDDM is not installed) (note the capital H!).\n"
printf "\n"
printf "It is highly recommended to reboot your system.\n\n"

sleep 5

