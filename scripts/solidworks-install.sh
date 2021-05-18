#!/bin/bash

# Name:         SOLIDWORKS - Installationsskript (Linux)
# Description:  With this file you can install SOLIDWORKS on Linux.
# Author:       Steve Zabka
# Author URI:   https://cryinkfly.de
# Time/Date:    21:00/18.05.2021
# Version:      0.2

# 1. Step: Open a Terminal and run this command: cd Downloads && chmod +x solidworks-install.sh && sh solidworks-install.sh
# 2. Step: The installation will now start and set up everything for you automatically.


# Find your correct package manager and install some packages (the minimum requirements), what you need for the installation of SOLIDWORKS!
if VERB="$( which apt-get )" 2> /dev/null; then
   echo "Debian-based"
   sudo dpkg --add-architecture i386  &&
   wget -nc https://dl.winehq.org/wine-builds/winehq.key &&
   sudo apt-key add winehq.key &&
   sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' &&
   sudo apt-get update &&
   sudo apt-get upgrade &&
   sudo apt-get install p7zip p7zip-full p7zip-rar curl winbind &&
   sudo apt-get install --install-recommends winehq-staging
elif VERB="$( which dnf )" 2> /dev/null; then
   echo "RedHat-based"
   sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm &&
   sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/34/winehq.repo
   sudo dnf update &&
   sudo dnf upgrade &&
   sudo dnf install p7zip p7zip-plugins curl wine cabextract
elif VERB="$( which pacman )" 2> /dev/null; then
   echo "Arch-based"
   sudo pacman -Syu &&
   pacman -S wine wine-mono wine_gecko
elif VERB="$( which zypper )" 2> /dev/null; then
   echo "openSUSE-based"
   su -c 'zypper up && zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.2/ wine && zypper install p7zip-full curl wine'
else
   echo "I have no idea what I'm doing." >&2
   exit 1
fi
if [[ 1 -ne $# ]]; then
   echo "Minimum requirements have been installed and set up for your system! "

# Installation of SOLIDWORKS:

   echo "The latest version of wintricks will be downloaded and executed."
   wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks &&
   chmod +x winetricks &&
   WINEPREFIX=~/.solidworks sh winetricks -q corefonts vcrun2019 msxml6 dxvk win10 &&
   
   echo "Solidworks will be installed and set up."
   mkdir solidworks &&
   cd solidworks &&
   wget https://dl-ak.solidworks.com/nonsecure/sw2020/sw2020_sp04.0_f/x64/200715.002-1-QA7UDVC9/SolidWorksSetup.exe &&
   
   WINEPREFIX=~/.solidworks wine SolidWorksSetup.exe
   
# Notice: You must change to another window (Filebrowser, ...) and come back to the installation window!
#         With this workaround can you only install SOLIDWORKS at the moment!!!

echo "The installation of SOLIDWORKS is completed."
   exit 1
fi
$VERB "$1"
exit $?
