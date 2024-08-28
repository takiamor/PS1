# Path to the file containing hostnames
$hostnamesFile = "C:\Users\ADMTCHI\Desktop\hostnames.txt"

# Path to the log file
$logFile = "C:\Users\ADMTCHI\Desktop\logfile.txt"

# Read all hostnames from the file
$hostnames = Get-Content -Path $hostnamesFile

# Script block to check for MMA and AMA installation
$scriptBlock = {
    # Get the hostname of the device
    $hostname = hostname

    # Check if Microsoft Monitoring Agent (MMA) is installed
    $mmaInstalled = Get-CimInstance -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%Microsoft Monitoring Agent%'" -ErrorAction SilentlyContinue

    # Check if Azure Monitor Agent (AMA) is installed
    $amaInstalled = Get-CimInstance -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%Azure Monitor Agent%'" -ErrorAction SilentlyContinue

    # Prepare results
    $result = "Hostname: $hostname`n"
    if ($mmaInstalled) {
        $result += "Microsoft Monitoring Agent (MMA) is installed.`n"
    } else {
        $result += "Microsoft Monitoring Agent (MMA) is not installed.`n"
    }

    if ($amaInstalled) {
        $result += "Azure Monitor Agent (AMA) is installed.`n"
    } else {
        $result += "Azure Monitor Agent (AMA) is not installed.`n"
    }

    return $result
}

# Initialize the log file
Out-File -FilePath $logFile -Force -InputObject "Log started on $(Get-Date)`n"

# Iterate over each hostname and execute the script block remotely
foreach ($hostname in $hostnames) {
    Write-Host "Checking host: $hostname"
    try {
        $output = Invoke-Command -ComputerName $hostname -ScriptBlock $scriptBlock
        Write-Host $output
        $output | Out-File -FilePath $logFile -Append
    } catch {
        $errorMessage = "Could not connect to $hostname. Error: $_"
        Write-Host $errorMessage
        $errorMessage | Out-File -FilePath $logFile -Append
    }
}

# Finish the log file
"Log ended on $(Get-Date)" | Out-File -FilePath $logFile -Append
