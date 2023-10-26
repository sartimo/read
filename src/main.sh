#!/bin/bash

# Function to check if a dep is installed
check_command() {
    if command -v "$1" &>/dev/null; then
    else
        echo "$1 is not installed but required"
        while true; do
            read -p "do you want to install $1 (yes/no)? " choice
            case "$choice" in
                [Yy]*)
                    sudo apt-get install -y "$1"
                    echo "$1 is now installed."
                    break
                    ;;
                [Nn]*)
                    break
                    ;;
                *)
                    echo "please enter 'yes' or 'no'."
                    ;;
            esac
        done
    fi
}

check_command "curl"
check_command "html2text"

file_path="~/.librc"

if [ -e "$file_path" ]; then
    echo "Found lib config at: $file_path"
else
    echo "File $file_path does not exist"
fi
