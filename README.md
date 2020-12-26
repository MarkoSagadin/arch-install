# Marko's Arch Linux Install scripts

## Disclaimer

Always check what you are running, this script will assume several things:
* That you are using AMD processor (cause of amd-code)
* That you are running dual boot with Windows (refind UEFI stuff)
Always open the script and check that this is what you want.
* You still have to manually partition the disks that you intend to use.
* After running `post_install` you still need to run manual commands, follow printed instructions.

## Instructions

1. Download the latest Arch Linux ISO from https://www.archlinux.org/download/

2. Flash it to a USB drive using a tool of your choice. I recommend Etcher if you're on Linux and Rufus on Windows.

3. Boot using the USB drive:

4. Partition the disk, create root, swap and efi if needed, format them and mount them.
This is described in Arch install guide.

5. Run the following commands on the terminal:
```bash
sudo pacman -Sy
sudo pacman -S git
git clone https://github.com/MarkoSagadin/arch-install.git
cd arch-setup
./install.sh
```

6. Run `post_install.sh` script and follow instructions afterwards

```bash
./install.sh
```
