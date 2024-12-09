#!/bin/bash
#set -e
#set -x
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue

echo
tput setaf 2
echo "################################################################"
echo "BUILDING SCRIPT"
echo "################################################################"
tput sgr0
echo

#read -p "Do you want to get the scripts from the internet? (yes/y/Y or no/n/N) " user_choice
# Normalize user input to lowercase
#user_choice=$(echo "$user_choice" | tr '[:upper:]' '[:lower:]')

user_choice="y"

# install packages
sudo pacman -S --noconfirm --needed alacritty
sudo pacman -S --noconfirm --needed arandr
sudo pacman -S --noconfirm --needed arcolinux-dwm-st-git
sudo pacman -S --noconfirm --needed arcolinux-nlogout-git
sudo pacman -S --noconfirm --needed arcolinux-powermenu-git
sudo pacman -S --noconfirm --needed btop
sudo pacman -S --noconfirm --needed dex
sudo pacman -S --noconfirm --needed feh
sudo pacman -S --noconfirm --needed flameshot-git
sudo pacman -S --noconfirm --needed gnome-screenshot
sudo pacman -S --noconfirm --needed go
sudo pacman -S --noconfirm --needed imlib2
sudo pacman -S --noconfirm --needed lxappearance
sudo pacman -S --noconfirm --needed numlockx
sudo pacman -S --noconfirm --needed picom-git
sudo pacman -S --noconfirm --needed rofi-lbonn-wayland
sudo pacman -S --noconfirm --needed scrot
sudo pacman -S --noconfirm --needed sxhkd
sudo pacman -S --noconfirm --needed xfce4-screenshooter
sudo pacman -S --noconfirm --needed xorg-xrandr

# File management
if [ -d sunset ]; then
	sudo rm -r sunset
fi
if [ -d sysmon ] ; then
	sudo rm -r sysmon
fi

if [ ! -d ~/.config/sunset ]; then
	mkdir ~/.config/sunset
fi

# making sure we can select sunset in SDDM, ...
sudo cp -vf sunset.desktop /usr/share/xsessions/sunset.desktop

# copying files to ~/.config/sunset
cp -v autostart.sh ~/.config/sunset
cp -v sxhkdrc ~/.config/sunset
cp -v picom-toggle.sh ~/.config/sunset
# copying folders to ~/.config/sunset
cp -rv launcher ~/.config/sunset
cp -rv scripts ~/.config/sunset
cp -rv picom ~/.config/sunset

# start from the official github of Dwm
git clone https://git.suckless.org/dwm sunset

# copy the rebuild script to sunset
cp -v rebuild.sh sunset

# copy over themes
mkdir sunset/themes
cp -v themes/* sunset/themes

# offical patches
mkdir sunset/patches
cp -v get-patches.sh sunset/patches
cd sunset/patches

# Perform the action based on user's choice
if [ "$user_choice" = "yes" ] || [ "$user_choice" = "y" ]; then
	echo
	tput setaf 2
	echo "################################################################"
	echo "GET PATCHES FROM ONLINE"
	echo "################################################################"
	tput sgr0
	echo
	sh get-patches.sh
	cd ..
else
	echo
	tput setaf 2
	echo "################################################################"
	echo "GET PATCHES FROM BACKUP FOLDER"
	echo "################################################################"
	tput sgr0
	echo
	echo $(pwd)
	cp ../../patches-backup/* ../patches
	cd ..
fi

echo
tput setaf 2
echo "################################################################"
echo "PATCHED PATCHES"
echo "################################################################"
tput sgr0
echo

# patched patches + copy
mkdir patched-patches
cp -v ../patched-patches/* patched-patches

## testing patch
#patch < patches/dwm-systray-20230922-9f88553.diff
#sh rebuild.sh
#exit 1

# start of patching
echo
tput setaf 2
echo "################################################################"
echo "Patch 1"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-cfacts-vanitygaps-6.4_combo.diff
echo
tput setaf 2
echo "################################################################"
echo "Patch 2"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-alpha-20230401-348f655.diff
echo
tput setaf 2
echo "################################################################"
echo "Patch 3"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-autostart-20210120-cb3f58a.diff

echo "Change directory for autostart"
sed -i 's|static const char localshare\[] = ".local/share";|static const char localshare\[] = ".config";|' dwm.c

echo
tput setaf 2
echo "################################################################"
echo "Patch 4"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-bartoggle-6.4.diff
echo
tput setaf 2
echo "################################################################"
echo "Patch 5"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-alwayscenter-20200625-f04cac6.diff
echo
tput setaf 2
echo "################################################################"
echo "Patch 6"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-dragmfact-6.2.diff

# personal patching as official did not work

echo
tput setaf 2
echo "################################################################"
echo "Patch 7"
echo "################################################################"
tput sgr0
echo
patch < patched-patches/dwm-cyclelayouts-2024-07-06.diff

echo
tput setaf 2
echo "################################################################"
echo "Patch 8"
echo "################################################################"
tput sgr0
echo
patch < patched-patches/dwm-r1615-2024-07-07.diff

echo
tput setaf 2
echo "################################################################"
echo "Patch 9"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-actualfullscreen-20211013-cb3f58a.diff

echo
tput setaf 2
echo "################################################################"
echo "Patch 10"
echo "################################################################"
tput sgr0
echo
patch < patched-patches/dwm-barpadding-20211020-a786211-2024-07-8.diff

echo
tput setaf 2
echo "################################################################"
echo "Patch 11"
echo "################################################################"
tput sgr0
echo
patch < patched-patches/chadwm-move-or-replace-2024-07-08.diff

echo
tput setaf 2
echo "################################################################"
echo "Patch 12"
echo "################################################################"
tput sgr0
echo
patch < patched-patches/dwm-bar-height-6.2-2024-07-08.diff

echo
tput setaf 2
echo "################################################################"
echo "Patch 13"
echo "################################################################"
tput sgr0
echo

patch < patched-patches/dwm-shif-tools-6.2-24-07-09.diff

# echo
# tput setaf 2
# echo "################################################################"
# echo "Patch 14"
# echo "################################################################"
# tput sgr0
# echo

# patch < patches/dwm-status2d-6.3.diff

# exit 1

echo
tput setaf 2
echo "################################################################"
echo "CHANGING MY PERSONAL PREFERENCES"
echo "################################################################"
tput sgr0
echo

# personal config
# move official patched config one level up
cp -v config.def.h ../config.def.h
cd ..

# change dmw to sunset
cp -vf Makefile sunset/Makefile

# compare the difference to get a diff
diff -u config.def.h config.def.custom.h > to-be-changed.diff
cp -v to-be-changed.diff sunset
cd sunset
patch < to-be-changed.diff

echo
tput setaf 2
echo "################################################################"
echo "BUILDING sunset"
echo "################################################################"
tput sgr0
echo

# Building sunset
sh rebuild.sh
cd ..


echo
tput setaf 2
echo "################################################################"
echo "BUILDING SYSMON"
echo "################################################################"
tput sgr0
echo

# Building Sysmon
# https://github.com/blmayer/sysmon
echo "Adding sysmon"
git clone https://github.com/blmayer/sysmon
cp sysmon.sh sysmon
cd sysmon
sed -i 's|PREFIX=${HOME}/.local|PREFIX=/usr|' Makefile
sh sysmon.sh

if [ -f /usr/local/bin/var ];then
	/usr/local/bin/var
fi

echo
tput setaf 2
echo "################################################################"
echo "################################################################"
echo "################################################################"
echo "COMPARE YOUR CUSTOM CONFIG.DEF.CUSTOM.H WITH CONFIG.DEF.H"
echo "OR ELSE INTRODUCE MISTAKES"
echo "################################################################"
echo "################################################################"
echo "################################################################"
tput sgr0
echo
