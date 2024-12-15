#!/bin/bash

# Set variables
declare -a sddm_packages=(
  qt6-5compat
  qt6-declarative
  qt6-svg
  sddm
)
declare -a login_managers=(
  lightdm
  gdm
  lxdm
  lxdm-gtk3
)
declare -a sddm_themes=(
  simple-sddm-2
)

# Check which AUR helper is installed
ISAUR=$(command -v yay || command -v paru)

install_packages() {
  # Checking if package is already installed
  if $ISAUR -Q "$1" &>> /dev/null ; then
    echo -e " $1 is already installed. Skipping..."
    sleep 1
  else
    # Package not installed
    echo -e " Installing $1 ..."
    sleep 1
    $ISAUR -S --noconfirm "$1"
    # Making sure package is installed
    if $ISAUR -Q "$1" &>> /dev/null ; then
      echo -e " $1 was installed."
      sleep 1
    else
      # Something is missing, exiting to review
      echo -e " $1 failed to install :( , please check manually! Sorry I have tried :("
      sleep 1
      exit 1
    fi
  fi
}

# Install SDDM and SDDM theme
for package in "${sddm_packages[@]}"; do
  install_packages "$package"
done

# Check if other login managers are installed and disabling their service before enabling sddm
for login_manager in "${login_managers[@]}"; do
  if pacman -Qs "$login_manager" > /dev/null; then
    echo "Disabling $login_manager..."
    sleep 1
    sudo systemctl disable "$login_manager.service"
  fi
done

# Enable SDDM service
sudo systemctl enable sddm
sleep 1

# Set up SDDM
echo -e " Setting up the login screen."
sleep 1
sddm_conf_dir=/etc/sddm.conf.d
if [ ! -d "$sddm_conf_dir" ]; then
  printf " $sddm_conf_dir not found, creating...\n"
  sleep 1
  sudo mkdir -p "$sddm_conf_dir"
fi

wayland_sessions_dir=/usr/share/wayland-sessions
if [ ! -d "$wayland_sessions_dir" ]; then
  printf " $wayland_sessions_dir not found, creating...\n"
  sleep 1
  sudo mkdir -p "$wayland_sessions_dir"
fi
sudo cp hyprland.desktop "$wayland_sessions_dir/"
sleep 1

# SDDM-themes

    printf "\n Installing Simple SDDM Theme\n"
    sleep 1

    if [ -d "/usr/share/sddm/themes/simple-sddm-2" ]; then
      sudo rm -rf "/usr/share/sddm/themes/simple-sddm-2"
      echo -e " Removed existing 'simple-sddm-2' directory."
      sleep 1
    fi

    if [ -d "simple-sddm-2" ]; then
      rm -rf "simple-sddm-2"
      echo -e " Removed existing 'simple-sddm-2' directory from the current location."
      sleep 1
    fi

    if git clone --depth 1 https://github.com/JaKooLit/simple-sddm-2.git; then
      while [ ! -d "simple-sddm-2" ]; do
        sleep 1
      done

      if [ ! -d "/usr/share/sddm/themes" ]; then
        sudo mkdir -p /usr/share/sddm/themes
        echo -e " Directory '/usr/share/sddm/themes' created."
        sleep 1
      fi

      sudo mv simple-sddm-2 /usr/share/sddm/themes/
      echo -e "[Theme]\nCurrent=simple-sddm-2" | sudo tee "$sddm_conf_dir/theme.conf.user"
    else
      echo -e " Failed to clone the theme repository. Please check your internet connection"
      sleep 1
    fi

