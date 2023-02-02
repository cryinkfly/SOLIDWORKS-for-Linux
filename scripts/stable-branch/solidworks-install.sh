#!/bin/bash

#####################################################################
# Name:         SOLIDWORKS - Installationsskript (Linux)            #
# Description:  With this file you can install SOLIDWORKS on Linux. #
# Author:       Steve Zabka                                         #
# Author URI:   https://cryinkfly.com                               #
# License:      MIT                                                 #
# Copyright (c) 2020-2021                                           #
# Time/Date:    11:15/18.11.2022                                    #
# Version:      0.7                                                 #
#####################################################################

##############################################################################
# DESCRIPTION
##############################################################################

# With the help of my script, You get a way to install the SOLIDWORKS on your Linux system. 
# Certain packages and programs that are required will be set up on your system.
#
# But it's important to know, that my script only helps You to get the program to run and nothing more!
#
# And so, You must to purchase the licenses directly from the manufacturer of the program SOLIDWORKS!
#
# Notice: You must change to another window (Filebrowser, ...) and come back to the installation window!
#         With this workaround can you only install SOLIDWORKS at the moment!!!

##############################################################################

############################################################################################################################################################
# 1. Step: Open a Terminal and run this command: cd Downloads && chmod +x solidworks-install.sh && bash solidworks-install.sh
# 2. Step: The installation will now start and set up everything for you automatically!
############################################################################################################################################################

##############################################################################
# ALL FUNCTIONS ARE ARRANGED HERE:
##############################################################################

# Here all languages are called up via an extra language file for the installation!

function languages {
    #wget https://github.com/cryinkfly/SOLIDWORKS-for-Linux/raw/main/scripts/stable-branch/languages.sh &&
    chmod +x languages.sh &&
    source ./languages.sh
}

##############################################################################

# The minimum requirements for installing SOLIDWORKS will be installed here!

function checkrequirement {
echo "$text_1"
echo -n "$text_1_1"
read answer
if [ "$answer" != "${answer#[YyJj]}" ] ;then
    install-requirement &&
    wmctrl -r ':ACTIVE:' -b toggle,fullscreen &&
    select-your-os
else
    exit;
fi
}

function installrequirement {
if VERB="$( which apt-get )" 2> /dev/null; then
   echo "Debian-based"
   sudo apt-get update &&
   sudo apt-get install dialog wmctrl software-properties-common
elif VERB="$( which dnf )" 2> /dev/null; then
   echo "RedHat-based"
   sudo dnf update &&
   sudo dnf install dialog wmctrl
elif VERB="$( which pacman )" 2> /dev/null; then
   echo "Arch-based"
   sudo pacman -Syu --needed dialog wmctrl grep gawk
elif VERB="$( which zypper )" 2> /dev/null; then
   echo "openSUSE-based"
   su -c 'zypper up && zypper install dialog wmctrl'
elif VERB="$( which xbps-install )" 2> /dev/null; then
   echo "Void-based"
   sudo xbps-install -Sy dialog wmctrl
elif VERB="$( which eopkg )" 2> /dev/null; then
   echo "Solus-based"
   sudo eopkg install dialog wmctrl
elif VERB="$( which emerge )" 2> /dev/null; then
    echo "Gentoo-based"
    sudo emerge -av dev-util/dialog x11-misc/wmctrl
else
   echo "I can't find your package manager!"
   exit;
fi
}

##############################################################################

# For the installation of SOLIDWORKS one of the supported Linux distributions must be selected! - Part 1

function selectyouros {
HEIGHT=15
WIDTH=200
CHOICE_HEIGHT=10
BACKTITLE="$text_2"
TITLE="$text_2_1"
MENU="$text_2_2"

OPTIONS=(1 "Arch Linux, Manjaro Linux, EndeavourOS, ..."
         2 "Debian 10, MX Linux 19.4, Raspberry Pi Desktop, ..."
         3 "Debian 11"
         4 "Fedora 33"
         5 "Fedora 34"
         6 "openSUSE Leap 15.2"
         7 "openSUSE Leap 15.3"
         8 "openSUSE Tumbleweed"
         9 "Red Hat Enterprise Linux 8.x"
         10 "Solus"
         11 "Ubuntu 18.04, Linux Mint 19.x, ..."
         12 "Ubuntu 20.04, Linux Mint 20.x, Pop!_OS 20.04, ..."
         13 "Ubuntu 20.10"
         14 "Ubuntu 21.04, Pop!_OS 21.04, ..."
         15 "Void Linux"
         16 "Gentoo Linux")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in         
        1)
            
            archlinux1
            ;;
            
        2)
        
            debianbased1 &&
            sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ buster main' &&
            debianbased2
            ;;  
            
        3)
        
            debian-based1 &&
            sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ bullseye main' &&
            debianbased2
            ;;  
            
        4)
            
            fedorabased1 &&
            sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/33/winehq.repo &&
            fedorabased2
            ;;  
            
        5) 
        
            fedorabased1 &&
            sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/34/winehq.repo &&
            fedorabased2
            ;;  
        
        6)
        
            su -c 'zypper up && zypper rr https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.2/ wine && zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.2/ wine && zypper install p7zip-full curl wget wine cabextract' &&
            selectyourpath
            ;;
            
        7)
            
            su -c 'zypper up && zypper rr https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.3/ wine && zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.3/ wine && zypper install p7zip-full curl wget wine cabextract' &&
            selectyourpath
            ;;  
            
        8)
            
            su -c 'zypper up && zypper install p7zip-full curl wget wine cabextract' &&
            selectyourpath
            ;;    
            
        9)
        
            redhatlinux &&
            selectyourpath
            ;;
            
        10)
        
            soluslinux &&
            selectyourpath
            ;;
            
        11) 
        
            debianbased1 &&
            sudo apt-add-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' &&
            wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key -O Release.key -O- | sudo apt-key add - &&
            sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./' &&
            debianbased2
            ;;
            
        12) 
            
            debianbased1 &&
            sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' &&
            wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.04/Release.key -O Release.key -O- | sudo apt-key add - &&
            sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.04/ ./' &&
            debianbased2
            ;;
            
        13) 
        
            debianbased1 &&
            sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ groovy main' &&
            wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.10/Release.key -O Release.key -O- | sudo apt-key add - &&
            sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.10/ ./' &&
            debianbased2
            ;;
            
        14)

            # Note: This installs the public key to trusted.gpg.d - While this is "acceptable" behaviour it is not best practice.
            # It is infinitely better than using apt-key add though.
            # For more information and for instructions to utalise best practices, see:
            # https://askubuntu.com/questions/1286545/what-commands-exactly-should-replace-the-deprecated-apt-key
            
            sudo apt update &&
            sudo apt upgrade &&
            sudo dpkg --add-architecture i386  &&
            mkdir -p /tmp/360 && cd /tmp/360 &&
            wget https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_21.04/Release.key &&
            wget https://dl.winehq.org/wine-builds/winehq.key &&
            gpg --no-default-keyring --keyring ./temp-keyring.gpg --import Release.key &&
            gpg --no-default-keyring --keyring ./temp-keyring.gpg --export --output opensuse-wine.gpg && rm temp-keyring.gpg &&
            gpg --no-default-keyring --keyring ./temp-keyring.gpg --import winehq.key &&
            gpg --no-default-keyring --keyring ./temp-keyring.gpg --export --output winehq.gpg && rm temp-keyring.gpg &&
            sudo mv *.gpg /etc/apt/trusted.gpg.d/ && cd /tmp && sudo rm -rf 360 &&
            echo "deb [signed-by=/etc/apt/trusted.gpg.d/opensuse-wine.gpg] https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_21.04/ ./" | sudo tee -a /etc/apt/sources.list.d/opensuse-wine.list
            sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ hirsute main' &&
            debianbased2
            ;;
            
        15)
        
            voidlinux &&
            selectyourpath
            ;;

        16)

            gentoolinux &&
            selectyourpath
            ;;

esac
}

##############################################################################

# For the installation of SOLIDWORKS one of the supported Linux distributions must be selected! - Part 2

function archlinux1 {

HEIGHT=15
WIDTH=60
CHOICE_HEIGHT=2
BACKTITLE="$text_3"
TITLE="$text_3_1"
MENU="$text_3_2"

OPTIONS=(1 "$text_3_3"
         2 "$text_3_4")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
            archlinux2 &&
            selectyourpath
            ;;
        2)
            if grep -q "#[multilib]" /etc/pacman.conf
            then
            echo "multilib already enabled, not writing to /etc/pacman.conf"
            else
            echo "multilib is not enabled, enabling it now"
            sudo awk -v RS="\0" -v ORS="" '{gsub(/#\[multilib\]\n#Include = \/etc\/pacman.d\/mirrorlist/,"[multilib]\nInclude = /etc/pacman.d/mirrorlist")}7' /etc/pacman.conf > /dev/null
            fi
            archlinux2 &&
            selectyourpath
            ;;
esac
}

function archlinux2 {
   sudo pacman -Syu --needed wine wine-mono wine_gecko winetricks p7zip curl cabextract samba ppp
}
   
function debianbased1 {
    sudo apt-get update &&
    sudo apt-get upgrade &&
    sudo dpkg --add-architecture i386  &&
    wget -nc https://dl.winehq.org/wine-builds/winehq.key &&
    sudo apt-key add winehq.key
}

function debianbased2 {
    sudo apt-get update &&
    sudo apt-get upgrade &&
    sudo apt-get install p7zip p7zip-full p7zip-rar curl winbind cabextract wget &&
    sudo apt-get install --install-recommends winehq-staging &&
    select-your-path
}

function fedorabased1 {
    sudo dnf update &&
    sudo dnf upgrade &&
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
}

function fedorabased2 {
    sudo dnf install p7zip p7zip-plugins curl wget wine cabextract &&
    select-your-path
}

function redhatlinux {
   sudo subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms &&
   sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm &&
   sudo dnf upgrade &&
   sudo dnf install wine
}

function soluslinux {
   sudo eopkg install wine winetricks p7zip curl cabextract samba ppp
}

function voidlinux {
   sudo xbps-install -Sy wine wine-mono wine-gecko winetricks p7zip curl cabextract samba ppp
}

function gentoolinux {
    sudo emerge -av virtual/wine app-emulation/winetricks app-emulation/wine-mono app-emulation/wine-gecko app-arch/p7zip app-arch/cabextract net-misc/curl net-fs/samba net-dialup/ppp
}

##############################################################################

# Here you can determine how SOLIDWORKS should be installed! (Installation location)

function selectyourpath {

HEIGHT=15
WIDTH=200
CHOICE_HEIGHT=2
CHOICE_WIDTH=200
BACKTITLE="$text_4"
TITLE="$text_4_1"
MENU="$text_4_2"

OPTIONS=(1 "$text_4_3"
         2 "$text_4_4")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

case $CHOICE in
        1)
            winetricksstandard
            ;;
        2)
            selectyourpathcustom &&
            winetrickscustom
            ;;
esac
}


function selectyourpathcustom {
    dialog --backtitle "$text_5" \
    --title "$text_5_1" \
    --msgbox "$text_5_2" 14 200

    filename=$(dialog --stdout --title "$text_5_3" --backtitle "$text_5_4" --fselect $HOME/ 14 100)
}

##############################################################################

# SOLIDWORKS will now be installed using Wine and Winetricks!

function winetricksstandard {
   mkdir -p "$HOME/.wineprefixes/solidworks" &&
   mkdir -p "$HOME/.wineprefixes/download/solidworks" &&
   cd "$HOME/.wineprefixes/downloads/solidworks" &&
   wget -N https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/raw/main/files/VBA/vba7.1.zip &&
   unzip vba7.1.zip &&
   cp -r vba7.1/Program*s $HOME/.wineprefixes/solidworks/drive_c &&
   cp -r vba7.1/Program*x86* $HOME/.wineprefixes/solidworks/drive_c &&
   cp -r vba7.1/windows $HOME/.wineprefixes/solidworks/drive_c &&
   wget -N https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks &&
   chmod +x winetricks &&
   WINEPREFIX=$HOME/.wineprefixes/solidworks sh winetricks -q corefonts vcrun2019 msxml6 dxvk win10 &&
   wget -N https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/raw/main/files/VBA/vba71-kb2783832-x64.msp &&
   WINEPREFIX=$HOME/.wineprefixes/solidworks msiexec /p vba71-kb2783832-x64.msp REINSTALL=ALL REINSTALLMODE=omus /qn
   wget https://dl-ak.solidworks.com/nonsecure/sw2022/sw2022_sp02.0_f/x64/220318.003-1-PGQH6ND3/SolidWorksSetup.exe -O Solidworks.exe &&
   WINEPREFIX=$HOME/.wineprefixes/solidworks wine Solidworks.exe &&
   logfileinstallationstandard &&
   programexit
}

function winetrickscustom {

   mkdir -p "$filename" &&
   mkdir -p "$filename/download/solidworks" &&
   cd "$filename/download/solidworks" &&
   wget -N https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/raw/main/files/VBA/vba7.1.zip &&
   unzip vba7.1.zip &&
   cp -r vba7.1/Program*s $filename/drive_c &&
   cp -r vba7.1/Program*x86* $filename/drive_c &&
   cp -r vba7.1/windows $filename/drive_c &&
   wget -N https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks &&
   chmod +x winetricks &&
   WINEPREFIX=$filename sh winetricks -q corefonts vcrun2019 msxml6 dxvk win10 &&
   wget -N https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/raw/main/files/VBA/vba71-kb2783832-x64.msp &&
   WINEPREFIX=$HOME/.wineprefixes/solidworks msiexec /p vba71-kb2783832-x64.msp REINSTALL=ALL REINSTALLMODE=omus /qn
   wget https://dl-ak.solidworks.com/nonsecure/sw2022/sw2022_sp02.0_f/x64/220318.003-1-PGQH6ND3/SolidWorksSetup.exe -O Solidworks.exe &&
   WINEPREFIX=$filename wine Solidworks.exe
   logfileinstallationcustom &&
   programexit
}

##############################################################################

# A log file will now be created here so that it can be checked in the future whether an installation of SOLIDWORKS already exists on your system.

function logfileinstallation {
   mkdir -p "/$HOME/.local/share/solidworks/logfiles" && 
   exec 5> /$HOME/.local/share/solidworks/logfiles/install-log.txt
   BASH_XTRACEFD="5"
   set -x
}

function logfileinstallationstandard {
   mkdir -p "/$HOME/.local/share/solidworks/logfiles" &&
   cd "/$HOME/.local/share/solidworks/logfiles" &&
   echo "/home/$USER/.wineprefixes/solidworks/logfiles" >> path-log.txt
}

function logfileinstallationcustom {
   mkdir -p "/$HOME/.local/share/solidworks/logfiles" &&
   cd "/$HOME/.local/share/solidworks/logfiles" &&
   echo "$filename" >> path-log.txt
}

##############################################################################

# The installation is complete and will be terminated.

function programexit {
    dialog --backtitle "$text_6" \
    --title "$text_6_1" \
    --msgbox "$text_6_2" 14 200
    
    clear
    exit
}

##############################################################################
# THE INSTALLATION PROGRAM IS STARTED HERE:
##############################################################################

logfileinstallation &&
languages &&
checkrequirement

############################################################################################################################################################
