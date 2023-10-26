

# Define the path to your file
$username = $env:USERNAME
$basePath = "C:/Users/${username}/booktmp/"

$pathExists = (Test-Path -Path "C:/Users/${username}/booktmp/")
if (!($pathExists)) {
    New-Item -ItemType Directory -Path "C:/Users/${username}/booktmp/"
}


$filePath = "C:/Users/${username}/booktmp/Readfile.txt"
$registryPath = "https://raw.githubusercontent.com/sartimo/read/main/Readfile"

Invoke-WebRequest -Uri $registryPath -OutFile $filePath
Write-Host "Successfully fetched Latest Readfile from ${registryPath}."
Write-Host "Saved to ${filePath}"
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

# Display a list of all link names
Write-Host "List of all available Books:"
Write-Host ""

$links.Keys | ForEach-Object {
    Write-Host $_
}

Write-Host ""

# Prompt the user to choose a link
$chosenLinkName = Read-Host "Enter the Book you want to read"

# Check if the chosen link name exists in the hashtable
if ($links.ContainsKey($chosenLinkName)) {
    # Store the chosen link in a variable
    $chosenLink = $links[$chosenLinkName]

    # Display the chosen link
    Write-Host "Chosen Book: $chosenLink"

    $linkExists = (Test-Path -Path "$basePath/$chosenLinkName.html")
    if (!($pathExists)) {
        Invoke-WebRequest -Uri $chosenLink -OutFile "$basePath/$chosenLinkName.html"

    }
} else {
    Write-Host "Book not found."
}
