#! /bin/bash

# This is Configuration script of Marko's Arch Linux Installation Package.

function install {
  which $1 &> /dev/null

  if [ $? -ne 0 ]; then
    echo "Installing: ${1}..."
    pacman -S --noconfirm $1
  else
    echo "Already installed: ${1}"
  fi
}

echo "Marko's Arch Post install script"

# Set date time
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

# Set locale to en_US.UTF-8 UTF-8
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Make keyboard layout persistent 
echo "KEYMAP=slovene" >> /etc/vconsole.conf

# Set hostname
echo "127.0.0.1	localhost
::1		    localhost
127.0.1.1	arch-omen.localdomain	arch-omen" >> /etc/hosts
echo "arch-omen" >> /etc/hostname

# Set root password
passwd

# Various installs 
# bootloader
install refind-efi                          
# processor specific
install amd-ucode
# graphics driver
install nvidia                              
# Desktop
install xorg                                
install xorg-server                         
install xfce4                               
install xfce4-goodies lightdm               
install lightdm-webkit2-greeter             
install lightdm-gtk-greeter-settings        
# Network
install wpa_supplicant                      
install wireless_tools                      
install networkmanager                      
install nm-connection-editor                
install network-manager-applet              
# Audio
install pavucontrol 
install pulseaudio 
install alsa-utils

refind-install

# Enable networking
systemctl enable NetworkManager.service

# Enable Lightdm greeter
sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-webkit2-greeter/g' /etc/lightdm/lightdm.conf
systemctl enable lightdm.service

echo "Most of configuration is done. 
You still need to create a new user and correctly setup rEFInd.
After that you can write 'exit'"
