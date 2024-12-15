#!/bin/bash

base_packages=(
  base-devel
  btop
  git
)

hypr_packages=(
  uwsm
)

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

# Determine the directory where the script is located
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
parent_dir="$script_dir/.."
cd "$parent_dir" || exit 1

echo -e "\n${NOTE} Installing hyprland packages....\n"

for package in "${hypr_packages[@]}" "${fonts[@]}" "${base_packages[@]}"; do
  install_package "$package"
  if [ $? -ne 0 ]; then
    echo -e "${ERROR} - $package install had failed, please check the log"
    exit 1
  fi
done

