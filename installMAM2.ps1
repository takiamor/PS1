# Define the path to the Azure Monitor Agent (AMA) installer
$amaInstallerPath = "\\prdadm037\e$\TOOLS\AzureMonitorAgentClientSetup.msi"

# Check if the installer exists at the specified path
if (Test-Path -Path $amaInstallerPath) {
    # Install the AMA
    Write-Host "Installing Azure Monitor Agent..."
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$amaInstallerPath`" /quiet /norestart" -Wait

    # Verify installation
    $amaInstalled = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%Azure Monitor Agent%'" -ErrorAction SilentlyContinue

    if ($amaInstalled) {
        Write-Host "Azure Monitor Agent (AMA) was installed successfully."
    } else {
        Write-Host "Azure Monitor Agent (AMA) installation failed."
    }
} else {
    Write-Host "Installer not found at path: $amaInstallerPath"
}
