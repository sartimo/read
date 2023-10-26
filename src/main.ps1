readfileLocation = "%APPDATA%/Roadming/Readfile"
readfileRegistry = "https://raw.githubusercontent.com/sartimo/read/main/Readfile"

if !(Test-Path -path $readfileLocation) {
    write-host "Readfile doesn't exist. Fetching latest Readfile from registry...\n"
    (New-Object System.Net.WebClient).DownloadFile(readfileRegistry, readfileLocation)  
} else {
    
}
