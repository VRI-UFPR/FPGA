#!/usr/bin/env python

import distro
import subprocess

def install_packages_mint():
    packages = []
    cmd = ["sudo", "apt", "install", "-y"] + packages
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def call_install_yay():
    print("Calling install-yay.py...")
    subprocess.run(["sudo", "python3", "./install-yay.py"])

def install_yay_packages():
    call_install_yay()
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

