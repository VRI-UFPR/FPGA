# Use the Arch Linux base image
FROM archlinux

# Install Bash in the container
RUN pacman -Sy --noconfirm bash sudo man binutils

# Set the working directory inside the container
WORKDIR /app

# Change the user to root
USER root

# Copy the needded files
COPY scripts/ ./scripts/ 
COPY digilent/ ./digilent/
COPY xilinx/ ./xilinx/

# Make the script executable
RUN chmod +x ./scripts/verify-python.sh

# Set the script as the default command
CMD ["./scripts/verify-python.sh"]

