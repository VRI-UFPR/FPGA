#!/usr/bin/env python

import os
import subprocess

def get_directory_with_prefix(root_folder, prefix):
    matching_directories = [d for d in os.listdir(root_folder) if os.path.isdir(os.path.join(root_folder, d)) and d.startswith(prefix)]
    return matching_directories[0]

def get_file_with_extension(root_folder, extension):
    matching_files = [d for d in os.listdir(root_folder) if os.path.isfile(os.path.join(root_folder, d)) and d.endswith(extension)]
    return matching_files[0]

def main():
    os.mkdir("build")
    os.chdir("build")

    print("Extracting xilinx...")
    file_path = get_file_with_extension("../../xilinx", ".tar")
    file_path = "../../xilinx/" + file_path
    cmd = "tar -xf " + file_path
    print("CMD: " + cmd)
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL)

    for d in os.listdir("."):
        print("dir: " + d)
    # xilinx_dir = get_directory_with_prefix(".", "Xilinx_ISE")
    # os.chdir(xilinx_dir)

    # print("Installing xilinx...")
    # cmd = "source ./install.sh"
    # subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL)

    os.chdir("..")
    cmd = "rm -rf build"
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL)

main()
