#!/bin/bash

# Function to check if Python is installed
check_python_installed() {
    if command -v python3 &>/dev/null; then
        return 0  # Python is installed
    else
        return 1  # Python is not installed
    fi
}

# Function to install Python based on the package manager
install_python() {
    if command -v apt-get &>/dev/null; then
        echo "Installing Python using apt-get..."
        sudo apt-get update > /dev/null
        sudo apt-get install -y python3 > /dev/null
    elif command -v pacman &>/dev/null; then
        echo "Installing Python using pacman..."
        sudo pacman -Sy --noconfirm python > /dev/null
    else
        echo "Unsupported package manager. Please install Python manually..."
        exit 1
    fi
}

# Main script
if check_python_installed; then
    echo "Python is already installed..."
else
    install_python
fi

# Call the install script
cd scripts
chmod +x ise-webpack.sh > /dev/null
source ise-webpack.sh
cd ../
