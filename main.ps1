# Define the path to your file
$filePath = ".\Readfile.txt"

# Initialize an empty hashtable to store the links
$links = @{}

# Read the file line by line
Get-Content -Path $filePath | ForEach-Object {
    # Split each line on the ":" character
    $parts = $_ -split ":", 2

    # Ensure the line contains both parts
    if ($parts.Count -eq 2) {
        # Trim leading and trailing spaces from link name and URL
        $linkName = $parts[0].Trim()
        $url = $parts[1].Trim()

        # Store the link and URL in the hashtable
        $links[$linkName] = $url
    }
}

# Prompt the user to choose a link
$chosenLinkName = Read-Host "Enter the Book you want to read"

# Check if the chosen link name exists in the hashtable
if ($links.ContainsKey($chosenLinkName)) {
    # Store the chosen link in a variable
    $chosenLink = $links[$chosenLinkName]

    # Display the chosen link
    Write-Host "Chosen Book: $chosenLink"
} else {
    Write-Host "Book not found."
}
