#!/bin/bash


nvidia_pkg=(
  nvidia-dkms
  nvidia-settings
  nvidia-utils
  libva
  libva-nvidia-driver-git
)


# printf "$ Checking for other hyprland packages and remove if any..\n"
# if pacman -Qs hyprland > /dev/null; then
#   printf "$ Hyprland detected. uninstalling to install Hyprland from official repo...\n"
#     for hyprnvi in hyprland-git hyprland-nvidia hyprland-nvidia-git hyprland-nvidia-hidpi-git; do
#     sudo pacman -R --noconfirm "$hyprnvi" 2>/dev/null 
#     done
# fi

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


# Install additional Nvidia packages
printf "$ Installing addition Nvidia packages...\n"
for krnl in $(cat /usr/lib/modules/*/pkgbase); do
  for NVIDIA in "${krnl}-headers" "${nvidia_pkg[@]}"; do
    install_packages "$NVIDIA" 
  done
done

# Check if the Nvidia modules are already added in mkinitcpio.conf and add if not
if grep -qE '^MODULES=.*nvidia. *nvidia_modeset.*nvidia_uvm.*nvidia_drm' /etc/mkinitcpio.conf; then
  echo "Nvidia modules already included in /etc/mkinitcpio.conf" 
else
  sudo sed -Ei 's/^(MODULES=\([^\)]*)\)/\1 nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf 
  echo "Nvidia modules added in /etc/mkinitcpio.conf"
fi

sudo mkinitcpio -P 
printf "\n\n\n"

# Additional Nvidia steps
NVEA="/etc/modprobe.d/nvidia.conf"
if [ -f "$NVEA" ]; then
  printf "${OK} Seems like nvidia-drm modeset=1 is already added in your system..moving on.\n"
  printf "\n"
else
  printf "\n"
  printf "$ Adding options to $NVEA..."
  sudo echo -e "options nvidia-drm modeset=1" | sudo tee -a /etc/modprobe.d/nvidia.conf 
  printf "\n"
fi



# Blacklist nouveau
    if [[ -z $blacklist_nouveau ]]; then
      read -n1 -rep "${CAT} Would you like to blacklist nouveau? (y/n)" blacklist_nouveau
    fi
echo
if [[ $blacklist_nouveau =~ ^[Yy]$ ]]; then
  NOUVEAU="/etc/modprobe.d/nouveau.conf"
  if [ -f "$NOUVEAU" ]; then
    printf "${OK} Seems like nouveau is already blacklisted..moving on.\n"
  else
    printf "\n"
    echo "blacklist nouveau" | sudo tee -a "$NOUVEAU" 
    printf "${NOTE} has been added to $NOUVEAU.\n"
    printf "\n"

    # To completely blacklist nouveau (See wiki.archlinux.org/title/Kernel_module#Blacklisting 6.1)
    if [ -f "/etc/modprobe.d/blacklist.conf" ]; then
      echo "install nouveau /bin/true" | sudo tee -a "/etc/modprobe.d/blacklist.conf" 
    else
      echo "install nouveau /bin/true" | sudo tee "/etc/modprobe.d/blacklist.conf" 
    fi
  fi
else
  printf "${NOTE} Skipping nouveau blacklisting.\n" 
fi



