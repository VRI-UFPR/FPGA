#!/usr/bin/env python

import subprocess

def is_yay_installed():
    try:
        subprocess.run(["pacman", "-Qi", "yay"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
        return True
    except subprocess.CalledProcessError:
        return False

def install_yay():
    if not is_yay_installed():
        # Clone yay repository from AUR
        cmd = "git clone https://aur.archlinux.org/yay.git"
        cmd += "&& cd yay"
        cmd += "&& makepkg -si"
        subprocess.run(cmd,shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def main():
    install_yay()

main()
