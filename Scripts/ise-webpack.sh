#!/bin/bash

# Function to remove the venv directory
cleanup_venv() {
    #echo "Cleaning up: Removing venv directory..."
    rm -rf venv
}

# Set up the trap to execute the cleanup function on script exit
trap cleanup_venv EXIT

# Check if the virtual environment directory exists
if [ ! -d "venv" ]; then
    # If the virtual environment doesn't exist, create it
    echo "Creating virtual environment..."
    python3 -m venv venv
fi

# Activate the virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Install dependencies (if needed)
pip install distro > /dev/null 2>&1 

# Run the Python script
echo "Running ise-webpack script..."
python3 ise-webpack.py

# Deactivate the virtual environment
echo "Deactivating virtual environment..."
deactivate
