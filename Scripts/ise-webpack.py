#!/usr/bin/env python

import subprocess

def call_install_required_packages():
    print("Calling install-required-packages.py...")
    subprocess.run(["sudo", "python3", "./install-required-packages.py"])

def call_install_git():
    print("Calling install-git.py...")
    subprocess.run(["sudo", "python3", "./install-git.py"])

def call_install_digilent():
    print("Calling install-digilent.py...")
    subprocess.run(["sudo", "python3", "./install-digilent.py"])

def call_install_xilinx():
    print("Calling install-xilinx.py...")
    subprocess.run(["sudo", "python3", "./install-xilinx.py"])

def main():
    call_install_required_packages()
    call_install_digilent()
    call_install_xilinx()
    
main()

