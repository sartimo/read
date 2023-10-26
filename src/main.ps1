# requires PScore6
iex "& { $(irm https://aka.ms/install-powershell.ps1) } -UseMSI -Preview"

readfileLocation = "%APPDATA%/Roadming/Readfile"
readfileRegistry = "https://raw.githubusercontent.com/sartimo/read/main/Readfile"

if !(Test-Path -path $readfileLocation) {
    write-host "Readfile doesn't exist. Fetching latest Readfile from registry...\n"
    (New-Object System.Net.WebClient).DownloadFile(readfileRegistry, readfileLocation)  
} else {
    # read Readfile
    # choose book
    # fetch book html
    # parse html into markdown
    # read ma
}
