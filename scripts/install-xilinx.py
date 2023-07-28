#!/usr/bin/env python

import subprocess

def get_directory_with_prefix(root_folder, prefix):
    matching_directories = [d for d in os.listdir(root_folder) if os.path.isdir(os.path.join(root_folder, d)) and d.startswith(prefix)]
    return matching_directories[0]

def main():
    os.mkdir("build")
    os.chdir("build")

    print("Extracting xilinx...")
    cmd = "tar -xvf ../xilinx/Xilinx_ISE_DS_Lin_14.7_1015_1.tar"
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL)

    folder_path = "."
    prefix_to_find = "Xilinx_ISE"
    xilinx_dir = get_directory_with_prefix(folder_path, prefix_to_find)

    os.chdir(xilinx_dir)
    print("Installing xilinx...")
    cmd = "source ./install.sh"
    subprocess.run(cmd, shell=True)
    os.chdir("..")

    cmd = "rm -rf build"
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL)

main()
