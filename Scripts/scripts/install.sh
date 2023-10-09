#!/bin/bash

# Function to remove the venv directory
cleanup_venv() {
    #echo "Cleaning up: Removing venv directory..."
    rm -rf venv
}

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
#
# Set up the trap to execute the cleanup function on script exit
trap cleanup_venv EXIT

if check_python_installed; then
    echo "Python is already installed..."
else
    install_python
fi

# Call the install script
cd scripts

# Check if the virtual environment directory exists
if [ ! -d "venv" ]; then
    # If the virtual environment doesn't exist, create it
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

pip install distro > /dev/null 2>&1 

# Run the Python script
echo "Running ise-webpack script..."
python3 ise-webpack.py

# Deactivate the virtual environment
echo "Deactivating virtual environment..."
deactivate

cd ../
