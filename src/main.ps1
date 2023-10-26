if ($ISWindows) {
    readfileLocation = "%APPDATA%/Roaming/Readfile"
} else {
    readfileLocation = "/etc/Readfile"
}

readfileRegistry = "https://raw.githubusercontent.com/sartimo/read/main/Readfile"

if !(Test-Path -path $readfileLocation) {
    write-host "Readfile doesn't exist. Fetching latest Readfile from registry...\n"
    (New-Object System.Net.WebClient).DownloadFile(readfileRegistry, readfileLocation)  
} else {

    # Initialize an empty hashtable to store the links
    $links = @{}
    
    # Read the file line by line
    Get-Content -Path $readfileLocation | ForEach-Object {
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
    $chosenLinkName = Read-Host "Enter the link name you want to choose"
    
    # Check if the chosen link name exists in the hashtable
    if ($links.ContainsKey($chosenLinkName)) {
        # Store the chosen link in a variable
        $chosenLink = $links[$chosenLinkName]
    
        # Display the chosen link
        Write-Host "Chosen Link: $chosenLink"
    } else {
        Write-Host "Link not found."
    }
    # read Readfile
    # choose book
    # fetch book html
    # parse html into markdown
    # read ma
}
