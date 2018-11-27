function Get-Pcap
{
    param( [string]$infile, [string]$outfile )
    
    $DebugPreference = "SilentlyContinue"
    
    # Find the text2pcap.exe executable, and set an alias to it.
    # If not found, ask for path, exit if the manually provided path is not valid.
    if (Test-Path 'C:\Program Files\Wireshark\text2pcap.exe') {
        Set-Alias -Name text2pcap -Value 'C:\Program Files\Wireshark\text2pcap.exe'
    } elseif (Test-Path 'C:\Program Files (x86)\Wireshark\text2pcap.exe') {
        Set-Alias -Name text2pcap -Value 'C:\Program Files (x86)\Wireshark\text2pcap.exe'
    } else {
        Write-Host "text2pcap.exe not found" -ForegroundColor Red
        $text2pcapLocation = Read-Host "Enter path to text2pcap.exe: "
        if (Test-Path $text2pcapLocation) {
            Set-Alias -Name text2pcap -Value $text2pcapLocation
        } else {
            Throw "text2pcap.exe not found, exiting"
            # exit
        }
    }

    #load raw input from CLI log
    $rawdata = Get-Content $infile
    # create an empty array to hold the cleaned-up data
    [System.Collections.ArrayList]$cleandata = @()

    foreach ($line in $rawdata) {
        if ($line -eq "") {
            # ignore empty lines, skip to next line
            continue
        }
        elseif ($line -match "^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}.\d{6}") {
            # process timestamps in "a" format
            $cleandata.Add($line.substring(0,26)) > $null
        }
        elseif ($line -match "^\d+.\d{6}.+ -> ") {
            # process timestamps in relative time format
            $cleandata.Add($line.Split(" ")[0]) > $null
        }
        elseif ($line.substring(0,2) -eq "0x") {
            # process data lines
            $finishedline = ""
            $brokenline = ($line -replace '\s+', ' ').Split(" ")
            $finishedline += ($BrokenLine[0] -replace "0x", "")
            
            $dataonly = $brokenline[1..($brokenline.Length - 2)]
            foreach ($hex in $dataonly) {
                if ($hex.Length -eq 2) {
                    $finishedline += " "+$hex
                }
                else {
                    # split the string in half, insert space inbetween and append to finished line
                    $finishedline += " "+$hex.substring(0,2) +" " + $hex.substring(2,2)
                }
            }
            $cleandata.Add($finishedline) > $null
        }
    }
    $cleandata | text2pcap -q -t "%Y-%m-%d %H:%M:%S." - $outfile
    # single "-" above signals "read input data from pipe"
    # need to add an option to handle relative time in timestamps
}
Export-ModuleMember -Function Get-Pcap