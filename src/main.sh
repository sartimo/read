#!/bin/bash

# Function to check if a dep is installed
check_command() {
    if command -v "$1" &>/dev/null; then
        continue
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
version="0.0.1"

# check if rcfile exist
if [ -e "$file_path" ]; then
    echo "found lib config at: $file_path"
else
    echo "file $file_path does not exist"
    echo "fetching config into $file_path..."

    curl https://raw.githubusercontent.com/sartimo/lib/main/.librc >> $file_path

    if [ $? -eq 0 ]; then
        echo "successfully fetched .librc from registry into $file_path"
    else
        echo "couldn't fetch rc file from registry. check internet connectivity"
    fi
fi

# Define usage information
usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -a    Execute function A"
    echo "  -b    Execute function B"
    echo "  -c    Execute function C"
    echo "  -h    Show help"
    exit 1
}

# Function A
fetch() {
    echo "Function A executed"
    # Add your code for function A here
}

# Function B
list() {
    echo "Function B executed"
    # Add your code for function B here
}

# Function C
version() {
    echo "Function C executed"
    # Add your code for function C here
}

# Parse options
while getopts "fetchlistversionhelp" opt; do
    case $opt in
        fetch)
            fetch
            ;;
        list)
            list
            ;;
        version)
            version
            ;;
        help)
            usage
            ;;
        \?)
            echo "invalid option: -$OPTARG"
            usage
            ;;
    esac
done

# If no options are provided or the options are not recognized, show usage
if [ $OPTIND -eq 1 ]; then
    usage
fi
