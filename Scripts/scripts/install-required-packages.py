#!/usr/bin/env python

import distro
import subprocess

def install_packages_mint():
    packages = []
    cmd = ["sudo", "apt", "install", "-y"] + packages
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def is_yay_installed():
    try:
        subprocess.run(["pacman", "-Qi", "yay"], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
        return True
    except subprocess.CalledProcessError:
        return False

def install_yay():
    if not is_yay_installed():
        print("Installing yay...")
        # Clone yay repository from AUR
        cmd = "git clone https://aur.archlinux.org/yay.git"
        cmd += "&& cd yay"
        cmd += "&& makepkg -si"
        subprocess.run(cmd,shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def install_yay_packages():
    install_yay();
    packages = ["ncurses5-compat-libs", "libstdc++5", "fxload"]
    cmd = ["sudo", "pacman", "-S", "--noconfirm"] + packages
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def install_packages_arch():
    packages = ["openmotif", "xorg-fonts-75dpi", "xorg-fonts-100dpi", "git",
                "make", "tar"]
    cmd = ["sudo", "pacman", "-S", "--noconfirm"] + packages
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    install_yay_packages()

def main():
    distro_info = distro.name()

    if "mint" in distro_info:
        print("Detected Linux Mint. Installing required packages...")
        install_packages_mint()
    else:
        print("Detected Arch Linux. Installing required packages...")
        install_packages_arch()

main()

