#!/usr/bin/env python

import subprocess
import os

def get_directory_with_prefix(root_folder, prefix):
    matching_directories = [d for d in os.listdir(root_folder) if os.path.isdir(os.path.join(root_folder, d)) and d.startswith(prefix)]
    return matching_directories[0]

def install_digilent():
    os.chdir("..")

    os.mkdir("build")
    os.chdir("build")
    
    print("Extracting digilent adept runtime...")
    cmd = "tar zxf ../digilent/digilent.adept.runtime_2.27.9-x86_64.tar.gz"
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL)

    cmd = "mkdir -p /usr/lib64/digilent/adept"
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL)

    folder_path = "."
    prefix_to_find = "digilent.adept.runtime"
    adept_runtime_dir = get_directory_with_prefix(folder_path, prefix_to_find)

    os.chdir(adept_runtime_dir)

    print("Installing digilent runtime...")
    cmd = "source ./install.sh < /usr/lib64/digilent/adept"
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    os.chdir("..")

    print("Extracting digilent adept utilities...")
    cmd = "tar zxf ../digilent/digilent.adept.utilities_2.7.1-x86_64.tar.gz"
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL)

    folder_path = "."
    prefix_to_find = "digilent.adept.utilities"
    adept_utilities_dir = get_directory_with_prefix(folder_path, prefix_to_find)

    os.chdir(adept_utilities_dir)

    cmd = "mkdir -p /usr/local/bin"
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL)

    cmd = "mkdir -p /etc/hotplug/usb/digilentusb"
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL)

    print("Installing digilent adept utilities...")
    cmd = "source ./install.sh < /usr/local/bin /usr/local/man"

    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    os.chdir("..")

    cmd = "rm -rf build"
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL)

def main():
    install_digilent()

main()

