#!/bin/bash

####################################################################################################
# Name:         Solidworks - Setup Wizard (Linux)                                                  #
# Description:  With this file you can install Solidworks on Linux.                                #
# Author:       Steve Zabka                                                                        #
# Author URI:   https://cryinkfly.com                                                              #
# License:      MIT                                                                                #
# Copyright (c) 2020-2021                                                                          #
# Time/Date:    15:00/10.11.2021                                                                   #
# Version:      1.0                                                                                #
####################################################################################################

###############################################################################################################################################################
# DESCRIPTION IN DETAIL                                                                                                                                       #
###############################################################################################################################################################
# With the help of my setup wizard, you will be given a way to install Solidworks on                                                                          #
# Linux so that you don't have to use Windows or macOS for this program in the future!                                                                        #
#                                                                                                                                                             #
# Also, my setup wizard will guides you through the installation step by step and will install some required packages.                                        #
#                                                                                                                                                             #
# The next one is you have the option of installing the program directly on your system or you can install it on an external storage medium.                  #
#                                                                                                                                                             #
# But it's important to know, you must to purchase the licenses directly from the manufacturer of Solidworks, when you will work with them on Linux!          #
###############################################################################################################################################################

###############################################################################################################################################################
# ALL FUNCTIONS ARE ARRANGED HERE:                                                                                                                            #
###############################################################################################################################################################

# Records the installation of Solidworks!
# This log file will later help with error analysis to find out why the installation did not work.

function logfile-installation {
   mkdir -p "/$HOME/.local/share/solidworks/logfiles" &&
   exec 5> /$HOME/.local/share/solidworks/logfiles/logfile-installation
   BASH_XTRACEFD="5"
   set -x
}

###############################################################################################################################################################

# It will check whether Solidworks is already installed on your system or not!

function check-if-solidworks-installer-exists {
solidworks_installer="$HOME/SOLIDWORKS/data/solidworks/Solidworks.exe" # Search for a existing installer of Solidworks
if [ -f "$solidworks_installer" ]; then
    echo "Solidworks installer exist!"
else
    load-solidworks-installer
fi
}

function check-if-solidworks-exists {
log_path="$HOME/.local/share/solidworks/logfiles/log-path" # Search for log files indicting install
if [ -f "$log_path" ]; then
    cp "$HOME/.local/share/solidworks/logfiles/log-path" data/logfiles
    new_modify_deinstall # Exists - Modify install
else
    logfile_install=1
    select-your-os # New install
fi
}

function logfile-installation-standard {
if [ $logfile_install -eq 1 ]; then
    echo "$HOME/.wineprefixes/solidworks" >> $HOME/.local/share/solidworks/logfiles/log-path
fi
}

function logfile-installation-custom {
if [ $logfile_install -eq 1 ]; then
   echo "$custom_directory" >> $HOME/.local/share/solidworks/logfiles/log-path
fi
}

###############################################################################################################################################################

# Create the structure for the installation of Solidworks!

function create-structure {
  mkdir -p data/solidworks
  mkdir -p data/logfiles
  mkdir -p data/locale
  mkdir -p data/locale/cs-CZ
  mkdir -p data/locale/de-DE
  mkdir -p data/locale/en-US
  mkdir -p data/locale/es-ES
  mkdir -p data/locale/fr-FR
  mkdir -p data/locale/it-IT
  mkdir -p data/locale/ja-JP
  mkdir -p data/locale/ko-KR
  mkdir -p data/locale/zh-CN
  mkdir -p data/winetricks
}

###############################################################################################################################################################

# Load the locale for the Setup Wizard!

function load-locale {
  wget -N -P data/locale https://github.com/cryinkfly/SOLIDWORKS-for-Linux/raw/main/files/scripts/stable-branch/data/locale/locale.sh
  chmod +x data/locale/locale.sh
  . data/locale/locale.sh
}

function load-locale-cs {
  . data/locale/cs-CZ/locale-cs.sh
}

function load-locale-de {
  . data/locale/de-DE/locale-de.sh
}

function load-locale-en {
  . data/locale/en-US/locale-en.sh
}

function load-locale-es {
  . data/locale/es-ES/locale-es.sh
}

function load-locale-fr {
  . data/locale/fr-FR/locale-fr.sh
}

function load-locale-it {
  . data/locale/it-IT/locale-it.sh
}

function load-locale-ja {
  . data/locale/ja-JP/locale-ja.sh
}

function load-locale-ko {
  . data/locale/ko-KR/locale-ko.sh
}

function load-locale-zh {
  . data/locale/zh-CN/locale-zh.sh
}

###############################################################################################################################################################

# Load the newest winetricks version for the Setup Wizard!

function load-winetricks {
  wget -N -P data/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
  chmod +x data/winetricks/winetricks
  }

###############################################################################################################################################################

# Load newest Solidworks installer version for the Setup Wizard!

function load-solidworks-installer {
  wget https://dl-ak.solidworks.com/nonsecure/sw2020/sw2020_sp04.0_f/x64/200715.002-1-QA7UDVC9/SolidWorksSetup.exe -O Solidworks.exe
  mv Solidworks.exe data/solidworks/Solidworks.exe
}

###############################################################################################################################################################

# For the installation of Solidworks one of the supported Linux distributions must be selected! - Part 2

function archlinux-1 {
    echo "Checking for multilib..."
    if archlinux-verify-multilib ; then
        echo "multilib found. Continuing..."
        archlinux-2
        select-your-path
    else
        echo "Enabling multilib..."
        echo "[multilib]" | sudo tee -a /etc/pacman.conf
        echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
        archlinux-2
        select-your-path
    fi
}

function archlinux-2 {
   sudo pacman -Sy --needed wine wine-mono wine_gecko winetricks p7zip curl cabextract samba ppp
}

function archlinux-verify-multilib {
    if cat /etc/pacman.conf | grep -q '^\[multilib\]$' ; then
        true
    else
        false
    fi
}

function debian-based-1 {
    sudo apt-get update
    sudo apt-get upgrade
    sudo dpkg --add-architecture i386
    wget -nc https://dl.winehq.org/wine-builds/winehq.key
    sudo apt-key add winehq.key
}

function debian-based-2 {
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get install p7zip p7zip-full p7zip-rar curl winbind cabextract wget
    sudo apt-get install --install-recommends winehq-staging
    select-your-path
}

function ubuntu18 {
    sudo apt-add-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
    wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key -O Release.key -O- | sudo apt-key add -
    sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./'
}

function ubuntu20 {
    sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
    wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.04/Release.key -O Release.key -O- | sudo apt-key add -
    sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.04/ ./'
}

function ubuntu20_10 {
    sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ groovy main'
    wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.10/Release.key -O Release.key -O-
    sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.10/ ./'
}

function ubuntu21 {
    # Note: This installs the public key to trusted.gpg.d - While this is "acceptable" behaviour it is not best practice.
    # It is infinitely better than using apt-key add though.
    # For more information and for instructions to utalise best practices, see:
    # https://askubuntu.com/questions/1286545/what-commands-exactly-should-replace-the-deprecated-apt-key

    sudo apt update
    sudo apt upgrade
    sudo dpkg --add-architecture i386
    mkdir -p /tmp/360 && cd /tmp/360
    wget https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_21.04/Release.key
    wget https://dl.winehq.org/wine-builds/winehq.key
    gpg --no-default-keyring --keyring ./temp-keyring.gpg --import Release.key
    gpg --no-default-keyring --keyring ./temp-keyring.gpg --export --output opensuse-wine.gpg && rm temp-keyring.gpg
    gpg --no-default-keyring --keyring ./temp-keyring.gpg --import winehq.key
    gpg --no-default-keyring --keyring ./temp-keyring.gpg --export --output winehq.gpg && rm temp-keyring.gpg
    sudo mv *.gpg /etc/apt/trusted.gpg.d/ && cd /tmp && sudo rm -rf 360
    echo "deb [signed-by=/etc/apt/trusted.gpg.d/opensuse-wine.gpg] https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_21.04/ ./" | sudo tee -a /etc/apt/sources.list.d/opensuse-wine.list
    sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ hirsute main'
}

function ubuntu21_10 {
    # Verify the below repos exist and uncomment this block to replace the above after 21.10 release
    # echo "deb [signed-by=/etc/apt/trusted.gpg.d/opensuse-wine.gpg] https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_21.10/ ./" | sudo tee -a /etc/apt/sources.list.d/opensuse-wine.list &&
    # sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ impish main' &&

    ubuntu21
}

function fedora-based-1 {
    sudo dnf update
    sudo dnf upgrade
    sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
}

function fedora-based-2 {
    sudo dnf install p7zip p7zip-plugins curl wget wine cabextract
    select-your-path
}

function redhat-linux {
   sudo subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
   sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
   sudo dnf upgrade
   sudo dnf install wine
}

function solus-linux {
   sudo eopkg install wine winetricks p7zip curl cabextract samba ppp
}

function void-linux {
   sudo xbps-install -Sy wine wine-mono wine-gecko winetricks p7zip curl cabextract samba ppp
}

function gentoo-linux {
    sudo emerge -nav virtual/wine app-emulation/winetricks app-emulation/wine-mono app-emulation/wine-gecko app-arch/p7zip app-arch/cabextract net-misc/curl net-fs/samba net-dialup/ppp
}

###############################################################################################################################################################

# Solidworks will now be installed using Wine and Winetricks! - Standard

function winetricks-standard {
   mkdir -p "$HOME/.wineprefixes/solidworks"
   wget -N https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/raw/main/files/VBA/vba7.1.zip
   unzip vba7.1.zip 
   cp -r vba7.1/Program*s $HOME/.wineprefixes/solidworks/drive_c
   cp -r vba7.1/Program*x86* $HOME/.wineprefixes/solidworks/drive_c
   cp -r vba7.1/windows $HOME/.wineprefixes/solidworks/drive_c
   WINEPREFIX=$HOME/.wineprefixes/solidworks sh data/winetricks/winetricks -q corefonts vcrun2019 msxml6 dxvk win10
   wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/DXVK.reg
   WINEPREFIX=$HOME/.wineprefixes/solidworks wine regedit.exe DXVK.reg
   wget -N https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/raw/main/files/VBA/vba71-kb2783832-x64.msp
   WINEPREFIX=$HOME/.wineprefixes/solidworks msiexec /p vba71-kb2783832-x64.msp REINSTALL=ALL REINSTALLMODE=omus /qn
   WINEPREFIX=$HOME/.wineprefixes/solidworks wine /data/solidworks/Solidworks.exe
   logfile-installation-standard
   program-exit
}

###############################################################################################################################################################

# Solidworks will now be installed using Wine and Winetricks! - Custom

function winetricks-custom {
   mkdir -p "$HOME/.wineprefixes/solidworks"
   wget -N https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/raw/main/files/VBA/vba7.1.zip
   unzip vba7.1.zip 
   cp -r vba7.1/Program*s $custom_directory/drive_c
   cp -r vba7.1/Program*x86* $custom_directory/drive_c
   cp -r vba7.1/windows $custom_directory/drive_c
   WINEPREFIX=$custom_directory sh data/winetricks/winetricks -q corefonts vcrun2019 msxml6 dxvk win10
   wget -N https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux/raw/main/files/extras/opengl_dxvk/DXVK.reg
   WINEPREFIX=$custom_directory wine regedit.exe DXVK.reg
   wget -N https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/raw/main/files/VBA/vba71-kb2783832-x64.msp
   WINEPREFIX=$custom_directory msiexec /p vba71-kb2783832-x64.msp REINSTALL=ALL REINSTALLMODE=omus /qn
   WINEPREFIX=$custom_directory wine /data/solidworks/Solidworks.exe
   logfile-installation-custom
   program-exit
}

###############################################################################################################################################################

# Remove a exist Autodesk Fusion 360 (Wineprefix)!

function deinstall-exist-solidworks {
    deinstall-select-solidworks
    rm -r "$deinstall_directory"
    program-exit-uninstall
}

###############################################################################################################################################################
# ALL DIALOGS ARE ARRANGED HERE:                                                                                                                              #
###############################################################################################################################################################

# Progress indicator dialog

function progress-indicator-dialog {
  (
echo "5" ; sleep 1
echo "# The folder structure will be created." ; sleep 1
create-structure
echo "25" ; sleep 1
echo "# The locale files will be loaded." ; sleep 1
load-locale
echo "55" ; sleep 1
echo "# The wine- and winetricks Script is loaded." ; sleep 1
load-winetricks
echo "75" ; sleep 1
echo "# The Autodesk Fusion 360 installation file will be downloaded." ; sleep 1
check-if-solidworks-installer-exists
echo "90" ; sleep 1
echo "# The installation can now be started!" ; sleep 1
echo "100" ; sleep 1
) |
zenity --progress \
  --title="$program_name" \
  --text="The Setup Wizard is being configured ..." \
  --width=400 \
  --height=100 \
  --percentage=0

if [ "$?" = 0 ] ; then
        start-launcher
elif [ "$?" = 1 ] ; then
        zenity --question \
                 --title="$program_name" \
                 --text="Are you sure you want to cancel the installation?" \
                 --width=400 \
                 --height=100
        answer=$?

        if [ "$answer" -eq 0 ]; then
              exit;
        elif [ "$answer" -eq 1 ]; then
              progress-indicator-dialog
        fi
elif [ "$?" = -1 ] ; then
        zenity --error \
          --text="An unexpected error occurred!"
        exit;
fi
}

###############################################################################################################################################################

# Welcome Screen - Setup Wizard of Solidworks for Linux

function start-launcher {
  zenity --question \
         --title="$program_name" \
         --text="Would you like to install Autodesk Fusion 360 on your system?" \
         --width=400 \
         --height=100
  answer=$?

  if [ "$answer" -eq 0 ]; then
      configure-locale
  elif [ "$answer" -eq 1 ]; then
      exit;
  fi
}

###############################################################################################################################################################

# Configure the locale of the Setup Wizard

function configure-locale {

  response=$(zenity --list \
                    --radiolist \
                    --title="$program_name" \
                    --width=700 \
                    --height=500 \
                    --column="Select:" --column="Language:" \
                    TRUE "English (Standard)" \
                    FALSE "German" \
                    FALSE "Czech" \
                    FALSE "Spanish" \
                    FALSE "French" \
                    FALSE "Italian" \
                    FALSE "Japanese" \
                    FALSE "Korean" \
                    FALSE "Chinese")

[[ $response = "English (Standard)" ]] && load-locale-en && licenses-en

[[ $response = "German" ]] && load-locale-de && licenses-de

[[ $response = "Czech" ]] && load-locale-cs && licenses-cs

[[ $response = "Spanish" ]] && load-locale-es && licenses-es

[[ $response = "French" ]] && load-locale-fr && licenses-fr

[[ $response = "Italian" ]] && load-locale-it && licenses-it

[[ $response = "Japanese" ]] && load-locale-ja && licenses-ja

[[ $response = "Korean" ]] && load-locale-ko && licenses-ko

[[ $response = "Chinese" ]] && load-locale-zh && licenses-zh

[[ "$response" ]] || start-launcher
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - cs-CZ

function licenses-cs {

license_de=`dirname $0`/data/locale/cs-CZ/license-cs

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_cs \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-solidworks-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
	      ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - de-DE

function licenses-de {

license_de=`dirname $0`/data/locale/de-DE/license-de

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_de \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-solidworks-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
	      ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - en-US

function licenses-en {

license_en=`dirname $0`/data/locale/en-US/license-en

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_en \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-solidworks-exists
	      ;;
    1)
        echo "Go back."
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
        ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - es-ES

function licenses-es {

license_es=`dirname $0`/data/locale/es-ES/license-es

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_es \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-solidworks-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
	      ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - fr-FR

function licenses-fr {

license_fr=`dirname $0`/data/locale/fr-FR/license-fr

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_fr \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-solidworks-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
	      ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - it-IT

function licenses-it {

license_it=`dirname $0`/data/locale/it-IT/license-it

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_it \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-solidworks-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
      	;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - ja-JP

function licenses-ja {

license_ja=`dirname $0`/data/locale/ja-JP/license-ja

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_ja \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-solidworks-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
	      ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - ko-KR

function licenses-ko {

license_ko=`dirname $0`/data/locale/ko-KR/license-ko

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_ko \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-solidworks-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
	      ;;
esac
}

###############################################################################################################################################################

# Load & View the LICENSE AGREEMENT of this Setup Wizard - zh-CN

function licenses-zh {

license_zh=`dirname $0`/data/locale/zh-CN/license-zh

zenity --text-info \
       --title="$program_name" \
       --width=700 \
       --height=500 \
       --filename=$license_zh \
       --checkbox="$text_license_checkbox"

case $? in
    0)
        echo "Start the installation."
        check-if-solidworks-exists
	      ;;
    1)
        echo "Go back"
        configure-locale
	      ;;
    -1)
        zenity --error \
          --text="$text_error"
        exit;
      	;;
esac
}

###############################################################################################################################################################

# For the installation of Solidworks one of the supported Linux distributions must be selected! - Part 1

function select-your-os {
  response=$(zenity --list \
                    --radiolist \
                    --title="$program_name" \
                    --width=700 \
                    --height=500 \
                    --column="$text_select" --column="$text_linux_distribution" \
                    FALSE "Arch Linux, Manjaro Linux, EndeavourOS, ..." \
                    FALSE "Debian 10, MX Linux 19.4, Raspberry Pi Desktop, ..." \
                    FALSE "Debian 11" \
                    FALSE "Fedora 33" \
                    FALSE "Fedora 34" \
                    FALSE "openSUSE Leap 15.2" \
                    FALSE "openSUSE Leap 15.3" \
                    FALSE "openSUSE Tumbleweed" \
                    FALSE "Red Hat Enterprise Linux 8.x" \
                    FALSE "Solus" \
                    FALSE "Ubuntu 18.04, Linux Mint 19.x, ..." \
                    FALSE "Ubuntu 20.04, Linux Mint 20.x, Pop!_OS 20.04, ..." \
                    FALSE "Ubuntu 20.10" \
                    FALSE "Ubuntu 21.04, Pop!_OS 21.04, ..." \
                    FALSE "Ubuntu 21.10" \
                    FALSE "Void Linux" \
                    FALSE "Gentoo Linux")

[[ $response = "Arch Linux, Manjaro Linux, EndeavourOS, ..." ]] && archlinux-1

[[ $response = "Debian 10, MX Linux 19.4, Raspberry Pi Desktop, ..." ]] && debian-based-1 && sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ buster main' && debian-based-2

[[ $response = "Debian 11" ]] && debian-based-1 && sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/debian/ bullseye main' && debian-based-2

[[ $response = "Fedora 33" ]] && fedora-based-1 && sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/33/winehq.repo && fedora-based-2

[[ $response = "Fedora 34" ]] && fedora-based-1 && sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/34/winehq.repo && fedora-based-2

[[ $response = "openSUSE Leap 15.2" ]] && su -c 'zypper up && zypper rr https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.2/ wine && zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.2/ wine && zypper install p7zip-full curl wget wine cabextract' && select-your-path

[[ $response = "openSUSE Leap 15.3" ]] && su -c 'zypper up && zypper rr https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.3/ wine && zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.3/ wine && zypper install p7zip-full curl wget wine cabextract' && select-your-path

[[ $response = "openSUSE Tumbleweed" ]] && su -c 'zypper up && zypper install p7zip-full curl wget wine cabextract' && select-your-path

[[ $response = "Red Hat Enterprise Linux 8.x" ]] && redhat-linux && select-your-path

[[ $response = "Solus" ]] && solus-linux && select-your-path

[[ $response = "Ubuntu 18.04, Linux Mint 19.x, ..." ]] && debian-based-1 && ubuntu18 && debian-based-2

[[ $response = "Ubuntu 20.04, Linux Mint 20.x, Pop!_OS 20.04, ..." ]] && debian-based-1 && ubuntu20 && debian-based-2

[[ $response = "Ubuntu 20.10" ]] && debian-based-1 && ubuntu20_10 && debian-based-2

[[ $response = "Ubuntu 21.04, Pop!_OS 21.04, ..." ]] && ubuntu21 && debian-based-2

[[ $response = "Ubuntu 21.10" ]] && ubuntu21_10 && debian-based-2

[[ $response = "Void Linux" ]] && void-linux && select-your-path

[[ $response = "Gentoo Linux" ]] && gentoo-linux && select-your-path

[[ "$response" ]] || echo "Go back" && configure-locale
}

###############################################################################################################################################################

# Here you can determine how Solidworks should be instierlert! (Installation location)

function select-your-path {
  response=$(zenity --list \
                    --radiolist \
                    --title="$program_name" \
                    --width=700 \
                    --height=500 \
                    --column="$text_select" --column="$text_installation_location" \
                    TRUE "$text_installation_location_standard" \
                    FALSE "$text_installation_location_custom")

[[ $response = "$text_installation_location_standard" ]] && winetricks-standard

[[ $response = "$text_installation_location_custom" ]] && select-your-path-fusion360 && winetricks-custom

[[ "$response" ]] || echo "Go back" && abort-installation
}

###############################################################################################################################################################

# Create & Select a directory for your Solidworks!

function select-your-path-solidworks {
custom_directory=`zenity --file-selection --directory --title="$text_select_location_custom"`
}

###############################################################################################################################################################

# Solidworks has already been installed on your system and you will now be given various options to choose from!

function new_modify_deinstall {
  response=$(zenity --list \
                    --radiolist \
                    --title="$program_name" \
                    --width=700 \
                    --height=500 \
                    --column="$text_select" --column="$text_select_option" \
                    TRUE "$text_select_option_1" \
                    FALSE "$text_select_option_2" \
                    False "$text_select_option_3")

[[ $response = "$text_select_option_1" ]] && logfile_install=1 && view-exist-solidworks

[[ $response = "$text_select_option_2" ]] && edit-exist-solidworks

[[ $response = "$text_select_option_3" ]] && deinstall-view-exist-solidworks

[[ "$response" ]] || echo "Go back" && configure-locale

}

###############################################################################################################################################################

# View the path of your exist Solidworks! -View

function view-exist-solidworks {
  file=`dirname $0`/data/logfiles/log-path
  directory=`zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$file \
         --checkbox="$text_new_installation_checkbox"`

  case $? in
      0)
          select-your-path-solidworks
          winetricks-custom
  	      ;;
      1)
          echo "Go back"
          new_modify_deinstall
  	      ;;
      -1)
        zenity --error \
          --text="$text_error"
          exit;
  	      ;;
  esac

}

###############################################################################################################################################################

# View the path of your exist Solidworks! - edit-exist-solidworks

function edit-exist-solidworks {
  file=`dirname $0`/data/logfiles/log-path
  directory=`zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$file \
         --checkbox="$text_edit_installation_checkbox"`

  case $? in
      0)
          select-your-path-solidworks
          winetricks-custom
  	      ;;
      1)
          echo "Go back"
          new_modify_deinstall
  	      ;;
      -1)
        zenity --error \
          --text="$text_error"
          exit;
  	      ;;
  esac

}

###############################################################################################################################################################

# Deinstall a exist Solidworks installation!

function deinstall-view-exist-solidworks {
  file=`dirname $0`/data/logfiles/log-path
  directory=`zenity --text-info \
         --title="$program_name" \
         --width=700 \
         --height=500 \
         --filename=$file \
         --editable \
         --checkbox="$text_deinstall_checkbox"`

  case $? in
      0)
          zenity --question \
                 --title="$program_name" \
                 --text="$text_deinstall_question" \
                 --width=400 \
                 --height=100
          answer=$?

          if [ "$answer" -eq 0 ]; then
              echo "$directory" > $file
	      cp "$file" $HOME/.local/share/solidworks/logfiles
              deinstall-exist-solidworks
          elif [ "$answer" -eq 1 ]; then
              deinstall-view-exist-solidworks
          fi

  	      ;;
      1)
          echo "Go back"
          new_modify_deinstall
  	      ;;
      -1)
        zenity --error \
          --text="$text_error"
          exit;
  	      ;;
  esac

}

###############################################################################################################################################################

# Select your exist Solidworks for the deinstallation!

function deinstall-select-solidworks {
  deinstall_directory=`zenity --file-selection --directory --title="$text_select_location_deinstall"`
}

###############################################################################################################################################################

# The uninstallation is complete and will be terminated.

function program-exit-uninstall {
  zenity --info \
  --width=400 \
  --height=100 \
  --text="$text_completed_deinstallation"

  exit;
}

###############################################################################################################################################################

# Abort the installation of Solidworks!

function abort-installation {
  zenity --question \
         --title="$program_name" \
         --text="$text_abort" \
         --width=400 \
         --height=100
  answer=$?

  if [ "$answer" -eq 0 ]; then
      exit;
  elif [ "$answer" -eq 1 ]; then
      select-your-path
  fi
}

###############################################################################################################################################################

# The installation is complete and will be terminated.

function program-exit {
  zenity --info \
  --width=400 \
  --height=100 \
  --text="$text_completed_installation"

  exit;
}

###############################################################################################################################################################

# The uninstallation is complete and will be terminated.

function program-exit-uninstall {
  zenity --info \
  --width=400 \
  --height=100 \
  --text="$text_completed_deinstallation"

  exit;
}

###############################################################################################################################################################
# THE INSTALLATION PROGRAM IS STARTED HERE:                                                                                                                   #
###############################################################################################################################################################

# Reset the logfile-value for the installation of Solidworks!
logfile_install=0

# Name of this program (Window Title)
program_name="Solidworks for Linux - Setup Wizard"

logfile-installation
progress-indicator-dialog
