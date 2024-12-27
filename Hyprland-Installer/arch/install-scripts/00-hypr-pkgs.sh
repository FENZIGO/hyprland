#!/bin/bash

base_packages=(
  base-devel
  btop
  git
  nano
  cachy-browser
  thunar
  wget
)

hypr_packages=(
  hyprland
  kitty
  rofi-wayland
  grim 
  swaync
  waybar
  xdg-desktop-portal-hyprland-git
  xdg-desktop-portal-gtk
  qt5-wayland
  qt6-wayland
  qt5ct
  qt6ct
  kvantum
)

install_package() {
  if yay -Q "$1" &> /dev/null; then
    echo -e "${OK} $1 is already installed. Skipping..."
    sleep 1
  else
    echo -e "${NOTE} Installing $1 ..."
    yay -S --noconfirm "$1"
    if yay -Q "$1" &> /dev/null; then
      echo -e "${OK} $1 was installed."
      sleep 3
    else
      echo -e "${ERROR} $1 kurwa
      sleep 3
      exit 1
    fi
  fi
}


script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
parent_dir="$script_dir/.."
cd "$parent_dir" || exit 1

echo -e "\n${NOTE} cosik idzie\n"
sleep 3
for package in "${hypr_packages[@]}" "${fonts[@]}" "${base_packages[@]}"; do
  install_package "$package"
  if [ $? -ne 0 ]; then
    echo -e "${ERROR} - $package chuj"
    exit 1
  fi
done

