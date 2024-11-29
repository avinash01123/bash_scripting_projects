#!/bin/bash
echo "Script to install Git"

# Function to check if a command exists and install it if not
check_and_install_command() {
    command_name="$1"
    install_command="$2"
    
    if ! command -v "$command_name" &>/dev/null; then
        echo "Error: '$command_name' is not installed or available in PATH."
        echo "Attempting to install '$command_name'..."
        
        # Try to install the command based on the OS
        if [ "$os_name" == "Linux" ]; then
            if [ "$command_name" == "curl" ]; then
                sudo apt update && sudo apt install curl -y
            elif [ "$command_name" == "sudo" ]; then
                sudo apt update && sudo apt install sudo -y
            elif [ "$command_name" == "apt" ]; then
                echo "Error: 'apt' is not available on this system. Please use another package manager."
                exit 1
            else
                echo "Error: Command '$command_name' requires manual installation."
                exit 1
            fi
        elif [ "$os_name" == "Darwin" ]; then
            if [ "$command_name" == "curl" ]; then
                brew install curl
            elif [ "$command_name" == "sudo" ]; then
                echo "sudo is typically pre-installed on macOS."
            elif [ "$command_name" == "apt" ]; then
                echo "'apt' is not available on macOS. Use 'brew' for package management."
                exit 1
            else
                echo "Error: Command '$command_name' requires manual installation."
                exit 1
            fi
        elif [[ "$os_name" == MINGW* || "$os_name" == CYGWIN* ]]; then
            if [ "$command_name" == "curl" ]; then
                echo "Error: 'curl' is not installed on Windows. Please install 'curl' and re-run the script."
                exit 1
            fi
        fi
    fi
}


# Detect the operating system
os_name=$(uname)

# Install necessary commands before proceeding
check_and_install_command "sudo" "apt"
check_and_install_command "curl" "curl"


# Install Git based on the operating system
if [ "$os_name" == "Linux" ]; then
    echo "This is a Linux box. Installing Git..."
    check_and_install_command "apt" "apt"  # Ensure apt is available
    sudo apt update
    sudo apt install git -y
    echo "Git installed successfully on Linux."

elif [ "$os_name" == "Darwin" ]; then
    echo "This is macOS. Installing Git..."
    check_and_install_command "brew" "brew"  # Ensure brew is available
    brew install git
    echo "Git installed successfully on macOS."

elif [[ "$os_name" == MINGW* || "$os_name" == CYGWIN* ]]; then
    echo "This is a Windows system. Installing Git..."
    
    # Check for curl (already done above)
    echo "Downloading Git for Windows..."
    curl -LO https://github.com/git-for-windows/git/releases/latest/download/Git-2.42.0-64-bit.exe
    echo "Running Git installer..."
    ./Git-2.42.0-64-bit.exe /VERYSILENT /NORESTART

    # Check if the installer executed successfully
    if [ $? -eq 0 ]; then
        echo "Git installed successfully on Windows."
        rm -f Git-2.42.0-64-bit.exe  # Cleanup installer
    else
        echo "Error: Git installer failed to execute. Please check manually."
    fi

else
    echo "Unsupported OS. Git installation not supported."
    exit 1
fi

# Confirm Git installation
if command -v git &>/dev/null; then
    echo "Git installation verified: $(git --version)"
else
    echo "Error: Git installation could not be verified."
    exit 1
fi

