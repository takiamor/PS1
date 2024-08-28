# Set variables
$installerPath = "C:\Path\To\Your\Installer.exe"  # Path to your local OCS Inventory NG Agent installer
$ocsServerUrl = "http://your-ocs-server/ocsinventory"  # Replace with your OCS Inventory server URL

# Check if the installer file exists
if (Test-Path -Path $installerPath) {
    Write-Output "OCS Inventory NG Agent installer found."

    # Run the installer silently
    Write-Output "Installing OCS Inventory NG Agent..."
    Start-Process -FilePath $installerPath -ArgumentList "/S /SERVER=$ocsServerUrl" -Wait

    Write-Output "OCS Inventory NG Agent installation completed!"
} else {
    Write-Output "Installer file not found at the specified path: $installerPath"
}
