#!/bin/bash

git clone https://aur.archlinux.org/yay-bin.git 
cd yay-bin 
makepkg -si --noconfirm 

yay -Syu --noconfirm

clear