# Read IP addresses from the file
$ipAddresses = Get-Content -Path "C:\Path\To\Your\File.txt"

# Specify the path to your PowerShell script
$scriptPath = "\\server\share\RemoveSophos.ps1"  # Update this with the actual path to your script

# Execute the script on each VM
foreach ($ip in $ipAddresses) {
    Invoke-Command -ComputerName $ip -ScriptBlock {
        param($scriptPath)
        # Execute the script on the remote VM
        & $scriptPath
    } -ArgumentList $scriptPath
}
