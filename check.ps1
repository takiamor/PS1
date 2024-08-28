# Get the hostname of the device
$hostname = hostname

# Check if Microsoft Monitoring Agent (MMA) is installed
$mmaInstalled = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%Microsoft Monitoring Agent%'" -ErrorAction SilentlyContinue

# Check if Azure Monitor Agent (AMA) is installed
$amaInstalled = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%Azure Monitor Agent%'" -ErrorAction SilentlyContinue

# Display results
Write-Host "Hostname: $hostname"
if ($mmaInstalled) {
    Write-Host "Microsoft Monitoring Agent (MMA) is installed."
} else {
    Write-Host "Microsoft Monitoring Agent (MMA) is not installed."
}

if ($amaInstalled) {
    Write-Host "Azure Monitor Agent (AMA) is installed."
} else {
    Write-Host "Azure Monitor Agent (AMA) is not installed."
}
