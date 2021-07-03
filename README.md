# SOLIDWORKS - Linux (Wine-Version)

![Bildschirmfoto vom 2021-05-18 17-55-41](https://user-images.githubusercontent.com/79079633/118688257-2e3d0e80-b806-11eb-825f-0b245f700c78.png)

Hello and Welcome on my GitHub-Channel "Crinkfly"!

My name is Steve and in this repository you can find some instructions for SOLIDWORKS, where you get a way to install this program on your system.
I will give you a feedback at different intervals, when there is something new.

My goal is that we can also use SOLIDWORKS on Linux and so we don't need longer two operating systems for this program, when we use this for our projects. I think this is a fantastic idea!

________________________________________________

You will get more information about this program, then you can visit the original website of SOLIDWORKS with this link: https://www.solidworks.com/
________________________________________________

You might want to use other CAD programs, then you can find more programs here:

  - Autodesk Fusion 360: https://github.com/cryinkfly/Fusion-360---Linux-Wine-Version-
  - SOLIDWORKS: https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-
  - ...
________________________________________________

Also you get more informations about SOLIDWORKS, when you visit my other channels:

  - Facebook:  https://www.facebook.com/cryinkfly/
  - Instagram: https://www.instagram.com/cryinkfly/
  - YouTube:   https://www.youtube.com/channel/UCJO-EOBPtlVv5OycHkFPcRg


![YouTube_channel](https://user-images.githubusercontent.com/79079633/119709635-b9994e00-be5d-11eb-976a-fca87b572af1.png)

________________________________________________

My system:

OS: openSUSE Leap 15.3 x86_64<br/>
Kernel: 5.3.18-57-default<br/>
DE: Xfce<br/>
CPU: Intel i7-7700HQ (8) @ 3.800GHz<br/>
GPU: NVIDIA GeForce GTX 1060 Mobile 6G (Community Repository Nvidia & CUDA Repository)<br/>
Memory: 32GB

Wine version: wine-6.12 (WINEARCH = win64)

________________________________________________

# Installation dosn't work correctly!!!

The installation of SOLIDWORKS hangs up here!

![Bildschirmfoto_2021-05-18_21-44-23](https://user-images.githubusercontent.com/79079633/118714067-cb0da500-b822-11eb-87ce-b3d84a1687f0.png)

________________________________________________

#### Installation on openSUSE Leap & Tumbleweed:

1.) Download my script: [Installation-Script](https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/blob/main/scripts/solidworks-install.sh)

2.) On openSUSE Tumbleweed you must delete the steps for adding the wine-Repository in my file "solidworks-install.sh"!
    
3.) Follow my instruction in my file "solidworks-install.sh" !

*Notice: Check if you have installed the newest graphics driver on your system!

________________________________________________________________________________________________


#### Installation on Ubuntu, Linux Mint, ...:

1.) Download my script: [Installation-Script](https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/blob/main/scripts/solidworks-install.sh)

2.) When you system use a newer based Ubuntu version as like Ubuntu (Focal Fossa), then you must change the wine-Repository in my file "solidworks-install.sh (Visit this site: https://wiki.winehq.org/Ubuntu)!
    
3.) Follow my instruction in my file "solidworks-install.sh" !

*Notice: Check if you have installed the newest graphics driver on your system!

________________________________________________________________________________________________


#### Installation on Fedora:

1.) Open a Terminal and run this command sudo nano /etc/hosts (Change this file!)

         127.0.0.1     localhost
         127.0.1.1     EXAMPLE-NAME
         
         ::1 ip6-localhost ip6-loopback
         fe00::0 ip6-localnet
         ff00::0 ip6-mcastprefix
         ff02::1 ip6-allnodes
         ff02::2 ip6-allrouters
         ff02::3 ip6-allhosts

2.) Run this command: sudo nano /etc/hostname (Change this file!)

        EXAMPLE-NAME

3.) Reboot your system

4.) Download my script: [Installation-Script](https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/blob/main/scripts/solidworks-install.sh)

5.) Follow my instruction in my file "solidworks-install.sh" !

*Notice: Check if you have installed the newest graphics driver on your system!
 
________________________________________________________________________________________________


#### Installation on Manjaro (based on Arch Linux): 

1.) Download my script: [Installation-Script](https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/blob/main/scripts/solidworks-install.sh)

2.) Follow my instruction in my file "solidworks-install.sh" !

*Notice: Check if you have installed the newest graphics driver on your system!

________________________________________________________________________________________________

#### Installation with Flatpak - EXPERIMENTAL:

1.) Look into my file [solidworks-install.sh](https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/blob/main/scripts/solidworks-install.sh) and install the the minimum requirements!

2.) Install Flatpak on your system: https://flatpak.org/setup/ (More information about FLatpak: https://youtu.be/SavmR9ZtHg0)

3.) Download my script: [Installation-Script](https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/blob/main/scripts/solidworks-flatpak-install.sh)

2.) Follow my instruction in my file "solidworks-flatpak-install.sh" !

*Notice: Check if you have installed the newest graphics driver on your system!

________________________________________________________________________________________________

##### Note: Simply ignore errors that occur during installation. 
#####       The installation of SOLIDWORKS was repeated several times to ensure that it really worked.

________________________________________________________________________________________________

##### Super Application Maintainer (WineHQ): https://appdb.winehq.org/objectManager.php?sClass=application&iId=318

- @cryinkfly (Administrator & Project Manager)

________________________________________________________________________________________________

#####        Special thanks go to these users:

- @cewbdex

... they help me to get work SOLIDWORKS on Linux!!!
________________________________________________________________________________________________

#### Which workspaces I have tested:

- Still in progress
________________________________________________________________________________________________

#### If you have some problems or a question:

https://github.com/cryinkfly/SOLIDWORKS-Linux-Wine-Version-/issues

