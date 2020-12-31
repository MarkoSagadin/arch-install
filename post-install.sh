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
ln -sf /usr/share/zoneinfo/Europe/Ljubljana /etc/localtime
hwclock --systohc

# Set locale to en_US.UTF-8 UTF-8
sed -i '/en_US.UTF-8 UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Make keyboard layout persistent 
echo "KEYMAP=slovene" >> /etc/vconsole.conf

# Set hostname
echo "127.0.0.1	localhost
::1	localhost
127.0.1.1	arch-omen.localdomain	arch-omen" >> /etc/hosts
echo "arch-omen" >> /etc/hostname

# Set root password
passwd

# Find good mirrors for fast downloads
pacman -Sy
pacman -S --noconfirm reflector rsync
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
sudo reflector --verbose --country 'Slovenia' -l 5 --sort rate --save /etc/pacman.d/mirrorlist

# Various installs 
install git
install firefox
# bootloader
install refind-efi                          
# processor specific
install amd-ucode
# graphics driver
install nvidia                              
install nvidia-utils
install xf86-video-amdgpu                              
install mesa
# Desktop
install xorg                                
install xorg-server                         
install xorg-init
install xorg-apps
install i3-wm
install lightdm               
install lightdm-gtk-greeter-settings        
install rofi
install dmenu
install conky
install thunar
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
# Create user directories
install xdg-user-dirs 

# Install bootloader
refind-install
cp -rfv refind_linux.conf /boot


# Blacklist opensource nvidia driver as we are using proprietary one.
echo "blacklist nouveau" >> /usr/lib/modprobe.d/nvidia.conf


# Enable networking
systemctl enable NetworkManager.service

# Enable Lightdm greeter, set to use i3 and fix one setting
sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/g' /etc/lightdm/lightdm.conf
sed -i 's/#logind-check-graphical=false/logind-check-graphical=true/g' /etc/lightdm/lightdm.conf
sed -i 's/#autologin-session=/autologin-session=i3/g' /etc/lightdm/lightdm.conf

systemctl enable lightdm.service

# Run to create user directories for the first time
xdg-user-dirs-update

# Create new user
read -p "Type the name of the new user" newuser
useradd -m -G wheel,storage,power $newuser
passwd $newuser
echo "----------------------------------------------------------------------------"
echo "Enable sudo privileges for a newly created user $newuser"
echo "Find line '%wheel ALL=(ALL) ALL' and uncomment it"
read -p "Press any key to continue.." tmpvar
EDITOR=vim visudo

echo "----------------------------------------------------------------------------"
echo "Most of configuration is done."
echo "You still need to correctly setup rEFInd."
echo "To do that run 'blkid /dev/<your_root_partition> >> /boot/refind_linux.conf'"
echo "Open refind_linux.conf file and from the last line copy PARTUUID string into upper three lines."
echo "Delete last line"
echo "After that you can write 'exit'"
