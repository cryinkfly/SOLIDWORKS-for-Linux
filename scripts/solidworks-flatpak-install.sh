#!/bin/bash

# Name:         SOLIDWORKS - Installationsskript - Flatpak (Linux)
# Description:  With this file you can install SOLIDWORKS on Linux.
# Author:       Steve Zabka
# Author URI:   https://cryinkfly.de
# Time/Date:    18:00/18.05.2021
# Version:      0.1

# 1. Step: Install Flatpak on your system: https://flatpak.org/setup/ (More information about FLatpak: https://youtu.be/SavmR9ZtHg0)
# 2. Step: Open a Terminal and run this command: cd Downloads && chmod +x solidworks-flatpak-install.sh && sh solidworks-flatpak-install.sh
# 3. Step: The installation will now start and set up everything for you automatically.

####################################################################
# The next two steps are also very important for you, because on some Linux Distrubition you dosn't get to work Flatpak without these steps!!!
####################################################################

# 1. Step: Open a Terminal and run this command sudo nano /etc/hosts (Change this file wihtout # !)

#     127.0.0.1     localhost
#     127.0.1.1     EXAMPLE-NAME
     
#     ::1 ip6-localhost ip6-loopback
#     fe00::0 ip6-localnet
#     ff00::0 ip6-mcastprefix
#     ff02::1 ip6-allnodes
#     ff02::2 ip6-allrouters
#     ff02::3 ip6-allhosts

# 2. Step: Run this command: sudo nano /etc/hostname (Change this file wihtout # !)

#    EXAMPLE-NAME

# 3. Step: Reboot your system!

####################################################################

# Add the Flathub repository for your current user!!!
echo "Add the Flathub repository"
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo &&
flatpak -y --user install flathub                              \
        org.freedesktop.Platform/x86_64/20.08                  \
        org.freedesktop.Platform.Compat.i386/x86_64/20.08      \
        org.freedesktop.Platform.GL32.default/x86_64/20.08     \
        org.freedesktop.Platform.GL.default/x86_64/20.08       \
        org.freedesktop.Platform.VAAPI.Intel.i386/x86_64/20.08 \
        org.freedesktop.Platform.VAAPI.Intel/x86_64/20.08      \
        org.freedesktop.Platform.ffmpeg_full.i386/x86_64/20.08 \
        org.freedesktop.Platform.ffmpeg-full/x86_64/20.08

#Install some packages for Nvidia users
if [ -f /proc/driver/nvidia/version ]; then
echo "Install some packages for your Nvidia graphics card!"
    ver=$(nvidia-settings -q all |grep OpenGLVersion|grep NVIDIA|sed 's/.*NVIDIA \(.*\) /nvidia-\1/g'|sed 's/\./-/g')
    flatpak -y --user install flathub                 \
        org.freedesktop.Platform.GL.$ver   \
        org.freedesktop.Platform.GL32.$ver
fi
echo "Installation of some packages for your graphics card is completed!"

#Install a special Wine-Version (org.winehq.flatpak-proton-68-ge-1)
echo "Install a special Wine-Version!"
wget https://github.com/fastrizwaan/flatpak-wine-releases/releases/download/6.8-20210510/org.winehq.flatpak-proton-68-ge-1-6.8-20210510.flatpak &&
flatpak -y --user install flathub org.winehq.flatpak-proton-68-ge-1 &&

echo "Winetricks isntall some packages for you!"
flatpak run org.winehq.flatpak-proton-68-ge-1 winetricks -q corefonts vcrun2019 msxml6 dxvk win10 &&

echo "SOLIDWORKS will be installed and set up."
flatpak run org.winehq.flatpak-proton-68-ge-1 bash &&
cd $HOME &&
cd Downloads &&
mkdir solidworks &&
cd solidworks &&
wget https://dl-ak.solidworks.com/nonsecure/sw2020/sw2020_sp04.0_f/x64/200715.002-1-QA7UDVC9/SolidWorksSetup.exe &&

WINEPREFIX=~/.solidworks wine SolidWorksSetup.exe
   
# Notice: You must change to another window (Filebrowser, ...) and come back to the installation window!
#         With this workaround can you only install SOLIDWORKS at the moment!!!

echo "The installation of SOLIDWORKS is completed."
exit
