#!/bin/bash

# Define the path to your file
username=$USER
basePath="/home/$username/booktmp/"

# Check if the path exists, and create it if it doesn't
if [ ! -d "$basePath" ]; then
    mkdir -p "$basePath"
fi

filePath="/home/$username/booktmp/Readfile.txt"
registryPath="https://raw.githubusercontent.com/sartimo/read/main/Readfile"

# Download the file from the registry
curl -o "$filePath" "$registryPath"
echo "Successfully fetched Latest Readfile from $registryPath."
echo "Saved to $filePath"

# Initialize an empty associative array to store the links
declare -A links

# Read the file line by line
while IFS=: read -r linkName url; do
    # Trim leading and trailing spaces from link name and URL
    linkName="${linkName#"${linkName%%[![:space:]]*}"}"
    linkName="${linkName%"${linkName##*[![:space:]]}"}"
    url="${url#"${url%%[![:space:]]*}"}"
    url="${url%"${url##*[![:space:]]}"}"

    # Store the link and URL in the associative array
    links["$linkName"]="$url"
done < "$filePath"

# Display a list of all link names
echo "List of all available Books:"
echo ""

for linkName in "${!links[@]}"; do
    echo "$linkName"
done

echo ""

# Prompt the user to choose a link
read -p "Enter the Book you want to read: " chosenLinkName

# Check if the chosen link name exists in the associative array
if [ -v "links[$chosenLinkName]" ]; then
    # Store the chosen link in a variable
    chosenLink="${links[$chosenLinkName]}"

    # Display the chosen link
    echo "Chosen Book: $chosenLink"

    # Check if the file exists in the base path
    if [ ! -f "$basePath/$chosenLinkName.html" ]; then
        # Download the chosen link
        curl -o "$basePath/$chosenLinkName.html" "$chosenLink"
    fi
else
    echo "Book not found."
fi

# html2text "$basePath/$chosenLinkName.html" > "$basePath/$chosenLinkName.txt"

# Convert text file to a man page using pandoc
pandoc -s "$basePath/$chosenLinkName.html" -t man -o "$basePath/$chosenLinkName.1"

# Install the generated man page
sudo mkdir -p /usr/local/share/man/man1
sudo mv "$basePath/$chosenLinkName.1" /usr/local/share/man/man1/

# Update man page index
sudo mandb

# Display the man page
man "$chosenLinkName"
