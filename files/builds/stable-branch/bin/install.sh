#!/bin/bash

############################################################################################################################
# Name:         SOLIDWORKS - Installationsskript (Linux)                                                                   #
# Description:  With this file you can install SOLIDWORKS on different Linux distributions.                                #
# Author:       Steve Zabka                                                                                                #
# Author URI:   https://cryinkfly.com                                                                                      #
# License:      MIT                                                                                                        #
# Time/Date:    10:30/13.03.2023                                                                                           #
# Version:      0.8.0                                                                                                      #
# Requires:     dialog, wget, lsb-release                                                                                  #
############################################################################################################################

############################################################################################################################
# THE INITIALIZATION OF DEPENDENCIES AND CREATION OF THE STRUCTURES STARTS HERE:                                           #
############################################################################################################################

# Default-Path:
SP_PATH="$HOME/.solidworks"

# Reset the logfile-value for the installation of SOLIDWORKS.
SP_LOG_INSTALLATION=0

# Setting the text color scheme in the terminal:
RED='\033[0;31m'
NOCOLOR='\033[0m'

############################################################################################################################

# Check if the package "dialog" and "wget" is installed on your system.
function SP_CHECK_REQUIRED_COMMANDS {
SP_REQUIRED_COMMANDS=("dialog" "wget" "lsb-release")
    for cmd in "${SP_REQUIRED_COMMANDS[@]}"; do
        echo "Testing presence of ${cmd} ..."
        local path="$(command -v "${cmd}")"
        if [ -n "${path}" ]; then
            echo "All required packages are installed on your system!"
        else
            clear
            echo -e "${RED}The required packages 'dialog', 'wget' and 'lsb-release' not installed on your system!${NOCOLOR}"
            read -p "Would you like to install these packages on your system to continue the installation of SOLIDWORKS? (y/n)" yn
            case $yn in 
	            y ) SP_INSTALL_REQUIRED_COMMANDS;
	                SP_REQUIRED_COMMANDS;;
	            n ) echo -e "${RED}Exiting ...";
		             exit;;
	            * ) echo -e "${RED}Invalid Response!${NOCOLOR}";
		            exit 1;;
            esac
        fi
    done;
}

function SP_INSTALL_REQUIRED_COMMANDS {
if VERB="$( which apt-get )" 2> /dev/null; then
   echo "Debian-based"
   sudo apt-get update &&
   sudo apt-get install dialog wget lsb-release software-properties-common
elif VERB="$( which dnf )" 2> /dev/null; then
   echo "RedHat-based"
   sudo dnf update &&
   sudo dnf install dialog wget lsb-release
elif VERB="$( which pacman )" 2> /dev/null; then
   echo "Arch-based"
   sudo pacman -Syu --needed dialog wget lsb-release
elif VERB="$( which zypper )" 2> /dev/null; then
   echo "openSUSE-based"
   su -c 'zypper up && zypper in dialog wget lsb-release'
elif VERB="$( which xbps-install )" 2> /dev/null; then
   echo "Void-based"
   sudo xbps-install -Sy dialog wget lsb-release
elif VERB="$( which eopkg )" 2> /dev/null; then
   echo "Solus-based"
   sudo eopkg install dialog wget lsb-release 
elif VERB="$( which emerge )" 2> /dev/null; then
    echo "Gentoo-based"
    sudo emerge -av dev-util/dialog net-misc/wget sys-apps/lsb-release
else
   echo "I can't find your package manager!"
   exit;
fi
}

###############################################################################################################################################################

# Create a base structure for the installation of SOLIDWORKS.
function SP_CREATE_STRUCTURE {
    mkdir -p $SP_PATH/{bin,config,locale/{de-DE,en-US},cache,logs,servers,graphics,music,downloads/extensions,wineprefixes}
}

###############################################################################################################################################################

# Download all locale files ...
function SP_LOCALE_FILES {   
    wget -N -P "$SP_PATH/locale/en-US" --progress=dot "https://github.com/cryinkfly/SOLIDWORKS-for-Linux/raw/main/files/builds/stable-branch/locale/en-US/locale-en.sh" 2>&1 |\
    grep "%" |\
    sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g"  | dialog --gauge "Download Locale Index files" 10 100
    chmod +x "$SP_PATH/locale/en-US/locale-en.sh"
    sleep 1
    wget -N -P "$SP_PATH/locale/de-DE" --progress=dot "https://github.com/cryinkfly/SOLIDWORKS-for-Linux/raw/main/files/builds/stable-branch/locale/de-DE/locale-de.sh" 2>&1 |\
    grep "%" |\
    sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g"  | dialog --gauge "Download Locale DE files" 10 100
    chmod +x "$SP_PATH/locale/de-DE/locale-de.sh"
    sleep 1
}

function SP_CONFIG_LOCALE { 
    if [[ $SP_LOCALE = "02" ]]; then
    # shellcheck source=../locale/de-DE/locale-de.sh
    source "$SP_PATH/locale/de-DE/locale-de.sh"
    else
    # shellcheck source=../locale/en-US/locale-en.sh
    source "$SP_PATH/locale/en-US/locale-en.sh"
    fi
    SP_SHOW_LICENSE
}

###############################################################################################################################################################

# Download the newest winetricks version:
function SP_WINETRICKS_LOAD {
  wget -N -P "$SP_PATH/bin" --progress=dot "https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks" 2>&1 |\
  grep "%" |\
  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g"  | dialog --gauge "Download Winetricks" 10 100
  chmod +x "$SP_PATH/bin/winetricks"
}

###############################################################################################################################################################

function SP_SELECT_SOLIDWORKS_VERSION {
    if [[ $SP_SOLIDWORKS_VERSION = "02" ]]; then
    SP_SELECT_SOLIDWORKS
    else
    SP_SOLIDWORKS_LOAD
    fi
    SP_SELECT_SOLIDWORKS_VERSION
}

function SP_SELECT_SOLIDWORKS {
    SOLIDWORKS_EXE=$(dialog --backtitle "Setup - SOLIDWORKS for Linux [Build Version 0.8.0]" \
    --title "Delete a file" \
    --stdout --title "Please choose a file to delete" \
    --fselect "$HOME/Downloads/" 0 0)
    SP_SELECT_OS_VERSION
}

# Download SOLIDWORKS:
function SP_SOLIDWORKS_LOAD {
  wget -N -P "$SP_PATH/downloads" --progress=dot "https://dl-ak.solidworks.com/nonsecure/sw2022/sw2022_sp02.0_f/x64/220318.003-1-PGQH6ND3/SolidWorksSetup.exe" 2>&1 |\
  grep "%" |\
  sed -u -e "s,\.,,g" | awk '{print $2}' | sed -u -e "s,\%,,g"  | dialog --gauge "Download SOLIDWORKS 2022 ..." 10 100
  sleep 1
  SOLIDWORKS_EXE="$SP_PATH/downloads/SolidWorksSetup.exe"
  SP_SELECT_OS_VERSION
}

###############################################################################################################################################################
# ALL LOG-FUNCTIONS OF THE INSTALLATION ARE ARRANGED HERE:                                                                                                    #
###############################################################################################################################################################

# Provides information about setup actions during installation.
function SP_LOG_INSTALLATION {
  exec 5> "$SP_PATH/logs/setupact.log"
  BASH_XTRACEFD="5"
  set -x
}

###############################################################################################################################################################
# ALL OS-FUNCTIONS ARE ARRANGED HERE:                                                                                                                         #
###############################################################################################################################################################

function SP_LOAD_OS_PACKAGES {
  if [[ $SP_OS_VERSION = "01" ]]; then
    echo "Arch Linux"
    OS_ARCHLINUX
  elif [[ $SP_OS_VERSION = "02" ]]; then
    echo "Debian"
    OS_DEBIAN
  elif [[ $SP_OS_VERSION = "03" ]]; then
    echo "EndeavourOS"
    OS_ARCHLINUX
  elif [[ $SP_OS_VERSION = "04" ]]; then
    echo "Fedora"
    OS_FEDORA
  elif [[ $SP_OS_VERSION = "05" ]]; then
    echo "Linux Mint"
    OS_UBUNTU
  elif [[ $SP_OS_VERSION = "06" ]]; then
    echo "Manjaro Linux"
    OS_ARCHLINUX
  elif [[ $SP_OS_VERSION = "07" ]]; then
    echo "openSUSE Leap & TW"
    OS_OPENSUSE
  elif [[ $SP_OS_VERSION = "08" ]]; then
    echo "Red Hat Enterprise Linux"
    OS_REDHAT_LINUX
  elif [[ $SP_OS_VERSION = "9" ]]; then
    echo "Solus"
    OS_SOLUS_LINUX
  elif [[ $SP_OS_VERSION = "10" ]]; then
    echo "Ubuntu"
    OS_UBUNTU
  elif [[ $SP_OS_VERSION = "11" ]]; then
    echo "Void Linux"
    OS_VOID_LINUX
  elif [[ $SP_OS_VERSION = "12" ]]; then
    echo "Gentoo Linux"
    OS_GENTOO_LINUX
  else
    echo "No Linux distribution was selected!"
  fi
}

###############################################################################################################################################################

function OS_ARCHLINUX {
  echo "Checking for multilib..."
  if ARCHLINUX_VERIFY_MULTILIB ; then
    echo "multilib found. Continuing..."
    pkexec sudo pacman -Sy --needed wine wine-mono wine_gecko winetricks p7zip curl cabextract samba ppp
    SP_SOLIDWORKS_INSTALL
  else
    echo "Enabling multilib..."
    echo "[multilib]" | sudo tee -a /etc/pacman.conf
    echo "Include = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
    pkexec sudo pacman -Sy --needed wine wine-mono wine_gecko winetricks p7zip curl cabextract samba ppp
    SP_SOLIDWORKS_INSTALL
  fi
}

function ARCHLINUX_VERIFY_MULTILIB {
  if grep -q '^\[multilib\]$' /etc/pacman.conf ; then
    true
  else
    false
  fi
}

###############################################################################################################################################################

function OS_DEBIAN {
  # Check which version of Debian is installed on your system!
  OS_DEBIAN_VERSION=$(lsb_release -ds)
  if [[ $OS_DEBIAN_VERSION == *"Debian"*"10"* ]]; then
    DEBIAN_BASED_1
    OS_DEBIAN_10
    DEBIAN_BASED_2
  elif [[ $OS_DEBIAN_VERSION == *"Debian"*"11"* ]]; then
    DEBIAN_BASED_1
    OS_DEBIAN_11
    DEBIAN_BASED_2
  else
    echo "Your Linux distribution is not supported yet!"
  fi
}

function DEBIAN_BASED_1 {
  # Some systems require this command for all repositories to work properly and for the packages to be downloaded for installation!
  pkexec sudo apt-get --allow-releaseinfo-change update
  # Added i386 support for wine!
  sudo dpkg --add-architecture i386
}

function DEBIAN_BASED_2 {
  sudo apt-get update
  sudo apt-get install p7zip p7zip-full p7zip-rar curl winbind cabextract wget
  sudo apt-get install --install-recommends winehq-staging
  SP_SOLIDWORKS_INSTALL
}

function OS_DEBIAN_10 {
  sudo apt-add-repository -r 'deb https://dl.winehq.org/wine-builds/debian/ buster main'
  wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10//Release.key -O Release.key -O- | sudo apt-key add -
  sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_10/ ./'
}

function OS_DEBIAN_11 {
  sudo apt-add-repository -r 'deb https://dl.winehq.org/wine-builds/debian/ bullseye main'
  wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11//Release.key -O Release.key -O- | sudo apt-key add -
  sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/Debian_11/ ./'
}

###############################################################################################################################################################

function OS_UBUNTU {
  # Check which version of Ubuntu or Linux Mint is installed on your system!
  OS_UBUNTU_VERSION=$(lsb_release -ds)
  if [[ $OS_UBUNTU_VERSION == *"Ubuntu"*"18.04"* ]]; then
    DEBIAN_BASED_1
    OS_UBUNTU_18
    DEBIAN_BASED_2
  elif [[ $OS_UBUNTU_VERSION == *"Ubuntu"*"20.04"* ]]; then
    DEBIAN_BASED_1
    OS_UBUNTU_20
    DEBIAN_BASED_2
  elif [[ $OS_UBUNTU_VERSION == *"Ubuntu"*"22.04"* ]]; then
    DEBIAN_BASED_1
    OS_UBUNTU_22
    DEBIAN_BASED_2
  elif [[ $OS_UBUNTU_VERSION == *"Linux Mint"*"19"* ]]; then
    DEBIAN_BASED_1
    OS_UBUNTU_18
    DEBIAN_BASED_2
  elif [[ $OS_UBUNTU_VERSION == *"Linux Mint"*"20"* ]]; then
    DEBIAN_BASED_1
    OS_UBUNTU_20
    DEBIAN_BASED_2
  elif [[ $OS_UBUNTU_VERSION == *"Linux Mint"*"21"* ]]; then
    DEBIAN_BASED_1
    OS_UBUNTU_22
    DEBIAN_BASED_2
  else
    echo "Your Linux distribution is not supported yet!"
  fi
}

function OS_UBUNTU_18 {
  sudo apt-add-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
  wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/Release.key -O Release.key -O- | sudo apt-key add -
  sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/ ./'
}

function OS_UBUNTU_20 {
  sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
  wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.04/Release.key -O Release.key -O- | sudo apt-key add -
  sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_20.04/ ./'
}

function OS_UBUNTU_22 {
  sudo add-apt-repository -r 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
  wget -q https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_22.04/Release.key -O Release.key -O- | sudo apt-key add -
  sudo apt-add-repository 'deb https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_22.04/ ./'
}

###############################################################################################################################################################

function OS_FEDORA {
  # Check which version of Fedora is installed on your system!
  OS_FEDORA_VERSION=$(lsb_release -ds)
  if [[ $OS_FEDORA_VERSION == *"Fedora"*"36"* ]]; then
    FEDORA_BASED_1
    OS_FEDORA_36
    FEDORA_BASED_2
  elif [[ $OS_FEDORA_VERSION == *"Fedora"*"37"* ]]; then
    FEDORA_BASED_1
    OS_FEDORA_37
    FEDORA_BASED_2
  elif [[ $OS_FEDORA_VERSION == *"Fedora"*"Rawhide"* ]]; then
    FEDORA_BASED_1
    OS_FEDORA_RAWHIDE
    FEDORA_BASED_2
  else
    echo "Your Linux distribution is not supported yet!"
  fi
}

function FEDORA_BASED_1 {
  pkexec sudo dnf update
  sudo dnf upgrade
  sudo dnf install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
}

function FEDORA_BASED_2 {
  sudo dnf install p7zip p7zip-plugins curl wget wine cabextract
  SP_SOLIDWORKS_INSTALL
}

function OS_FEDORA_36 {
  sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/Emulators:/Wine:/Fedora/Fedora_36/Emulators:Wine:Fedora.repo
}

function OS_FEDORA_37 {
  sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/Emulators:/Wine:/Fedora/Fedora_37/Emulators:Wine:Fedora.repo
}

function OS_FEDORA_RAWHIDE {
  sudo dnf config-manager --add-repo https://download.opensuse.org/repositories/Emulators:/Wine:/Fedora/Fedora_Rawhide/Emulators:Wine:Fedora.repo
}

###############################################################################################################################################################

function OS_OPENSUSE {
  # Check which version of openSUSE is installed on your system!
  OS_OPENSUSE_VERSION=$(lsb_release -ds)
  if [[ $OS_OPENSUSE_VERSION == *"openSUSE"*"15.4"* ]]; then
    OS_OPENSUSE_154
  elif [[ $OS_OPENSUSE_VERSION == *"openSUSE"*"Tumbleweed"* ]]; then
    OS_OPENSUSE_TW
  elif [[ $OS_OPENSUSE_VERSION == *"openSUSE"*"MicroOS"* ]]; then
    OS_OPENSUSE_MICROOS #If you like to use WINE into a Distrobox Container!
  else
    echo "Your Linux distribution is not supported yet!"
  fi
}

function OS_OPENSUSE_154 {
  pkexec su -c 'zypper up && zypper rr https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.4/ wine && zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.4/ wine && zypper install p7zip-full curl wget wine cabextract'
  SP_SOLIDWORKS_INSTALL
}

# Has not been published yet!
function OS_OPENSUSE_155 {
  pkexec su -c 'zypper up && zypper rr https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.5/ wine && zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Leap_15.5/ wine && zypper install p7zip-full curl wget wine cabextract'
  SP_SOLIDWORKS_INSTALL
}

function OS_OPENSUSE_TW {
  pkexec su -c 'zypper dup && zypper rr https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Tumbleweed/ wine && zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Tumbleweed/ wine && zypper install p7zip-full curl wget wine cabextract'
  SP_SOLIDWORKS_INSTALL
}

function OS_OPENSUSE_MICROOS {
  sudo zypper dup && sudo zypper rr https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Tumbleweed/ wine && sudo zypper ar -cfp 95 https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Tumbleweed/ wine && sudo zypper install p7zip-full curl wget wine cabextract
  SP_SOLIDWORKS_INSTALL
}

###############################################################################################################################################################

function OS_REDHAT_LINUX {
  # Check which version of openSUSE is installed on your system!
  OS_REDHAT_LINUX_VERSION=$(lsb_release -ds)
  if [[ $OS_REDHAT_LINUX_VERSION == *"Red Hat Enterprise Linux"*"8"* ]]; then
    OS_REDHAT_LINUX_8
  elif [[ $OS_REDHAT_LINUX_VERSION == *"Red Hat Enterprise Linux"*"9"* ]]; then
    OS_REDHAT_LINUX_9
  else
    echo "Your Linux distribution is not supported yet!"
  fi
}


function OS_REDHAT_LINUX_8 {
  pkexec sudo subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms
  sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
  sudo dnf upgrade
  sudo dnf install wine
  SP_SOLIDWORKS_INSTALL
}

function OS_REDHAT_LINUX_9 {
  pkexec sudo subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
  sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
  sudo dnf upgrade
  sudo dnf install wine
  SP_SOLIDWORKS_INSTALL
}

###############################################################################################################################################################

function OS_SOLUS_LINUX {
  pkexec sudo eopkg install -y wine winetricks p7zip curl cabextract samba ppp
  SP_SOLIDWORKS_INSTALL
}

###############################################################################################################################################################

function OS_VOID_LINUX {
  pkexec sudo xbps-install -Sy wine wine-mono wine-gecko winetricks p7zip curl cabextract samba ppp
  SP_SOLIDWORKS_INSTALL
}

###############################################################################################################################################################

function OS_GENTOO_LINUX {
  pkexec sudo emerge -nav virtual/wine app-emulation/winetricks app-emulation/wine-mono app-emulation/wine-gecko app-arch/p7zip app-arch/cabextract net-misc/curl net-fs/samba net-dialup/ppp
  SP_SOLIDWORKS_INSTALL
}

###############################################################################################################################################################
# ALL WINEPREFIXES-FUNCTIONS ARE ARRANGED HERE:                                                                                                               #
###############################################################################################################################################################

function SP_SOLIDWORKS_INSTALL {
   cd "$SP_PATH/bin/winetricks"
   WINEPREFIX=$SP_PATH/wineprefixes/solidworks sh winetricks -q atmlib gdiplus corefonts vcrun2019 msxml4 msxml6 dxvk win10 &&
   WINEPREFIX=$SP_PATH/wineprefixes/solidworks sh winetricks -q win10 &&
   cd "$SP_PATH/downloads/extensions" &&
   wget -N https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/raw/main/files/VBA/vba7.1.zip &&
   unzip vba7.1.zip &&
   cp -r vba7.1/Program*s $SP_PATH/wineprefixes/solidworks/drive_c &&
   cp -r vba7.1/Program*x86* $SP_PATH/wineprefixes/solidworks/drive_c &&
   cp -r vba7.1/windows $SP_PATH/wineprefixes/solidworks/drive_c &&
   wget -N https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/raw/main/files/VBA/vba71-kb2783832-x64.msp &&
   WINEPREFIX=$SP_PATH/wineprefixes/solidworks msiexec /p vba71-kb2783832-x64.msp REINSTALL=ALL REINSTALLMODE=omus /qn
   WINEPREFIX=$SP_PATH/wineprefixes/solidworks wine $SOLIDWORKS_EXE &&
   SP_EXIT
}

###############################################################################################################################################################
# ALL DIALOGS ARE ARRANGED HERE:                                                                                                                              #
###############################################################################################################################################################

function SP_WELCOME {
  SP_LOCALE=$(dialog --backtitle "Setup - SOLIDWORKS for Linux [Build Version 0.8.0]" \
    --title "Welcome to the SOLIDWORKS for Linux Installer Wizard" \
    --radiolist "Please select your language to >Continue< with the installation or >Cancel< to exit this Installer Wizard." 0 0 0 \
       01 "English" on\
       02 "Deutsch" off 3>&1 1>&2 2>&3 3>&-)
  echo "$SP_LOCALE" > $SP_PATH/cache/settings.txt
  SP_CONFIG_LOCALE
}

###############################################################################################################################################################

function SP_SHOW_LICENSE {
  dialog --yesno "`cat $SP_LICENSE_FILE`" 0 0
  response=$?
  case $response in
     0) SP_SELECT_SOLIDWORKS_VERSION;; # Open the next dialog window for selecting the correct SOLIDWORKS Version.
     1) SP_SHOW_LICENSE_ERROR;; #Displays an error message that the license terms have not been accepted!
     255) echo "[ESC] key pressed.";; # Program has been terminated manually!
  esac
  
} 

function SP_SHOW_LICENSE_ERROR {
  dialog --yesno "$SP_LICENSE_ERROR" 0 0
  response=$?
  case $response in
     0) SP_SHOW_LICENSE;; # Open the next dialog for accept the license.
     1) exit;; # Program has been terminated manually!
     255) echo "[ESC] key pressed.";; # Program has been terminated manually!
  esac
  
}

###############################################################################################################################################################

function SP_SELECT_SOLIDWORKS_VERSION {
  SP_SOLIDWORKS_VERSION=$(dialog --backtitle "Setup - SOLIDWORKS for Linux [Build Version 0.8.0]" \
    --title "$SP_SELECT_SOLIDWORKS_VERSION_SUBTITLE" \
    --radiolist "$SP_SELECT_SOLIDWORKS_VERSION_TEXT" 0 0 0 \
       01 "SOLIDWORKS 2022" on\
       02 "Gentoo Linux" off 3>&1 1>&2 2>&3 3>&-)
  clear
  echo "$SP_SOLIDWORKS_VERSION" >> $SP_PATH/cache/settings.txt
  SP_SELECT_SOLIDWORKS_VERSION
}

###############################################################################################################################################################

function SP_SELECT_OS_VERSION {
  SP_OS_VERSION=$(dialog --backtitle "Setup - SOLIDWORKS for Linux [Build Version 0.8.0]" \
    --title "$SP_SELECT_OS_VERSION_SUBTITLE" \
    --radiolist "$SP_SELECT_OS_VERSION_TEXT" 0 0 0 \
       01 "Arch Linux" off\
       02 "Debian" off\
       03 "EndeavourOS" off\
       04 "Fedora" off\
       05 "Linux Mint" off\
       06 "Manjaro Linux" off\
       07 "openSUSE Leap & TW" off\
       08 "Red Hat Enterprise Linux" off\
       09 "Solus" off\
       10 "Ubuntu" off\
       11 "Void Linux" off\
       12 "Gentoo Linux" off 3>&1 1>&2 2>&3 3>&-)
  clear
  echo "$SP_OS_VERSION" >> $SP_PATH/cache/settings.txt
  SP_WINETRICKS_LOAD
  SP_SOLIDWORKS_LOAD
  SP_LOAD_OS_PACKAGES # Load the correct packages for your system for the next steps.
}

###############################################################################################################################################################

# The installation is complete and will be terminated.
function SP_EXIT {
    dialog --backtitle "Setup - SOLIDWORKS for Linux [Build Version 0.8.0]" \
    --title "$SP_EXIT_SUBTITLE" \
    --msgbox "$SP_EXIT_TEXT" 0 0
    clear
    exit
}

###############################################################################################################################################################
# THE INSTALLATION PROGRAM IS STARTED HERE:                                                                                                                   #
###############################################################################################################################################################

SP_LOG_INSTALLATION
SP_CHECK_REQUIRED_COMMANDS
SP_CREATE_STRUCTURE
SP_LOCALE_FILES
SP_WELCOME
