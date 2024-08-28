# Define the paths
$uninstallerPath = "\\prdadm037\e$\TOOLS\MMASetup-AMD64.exe"
$amaInstallerPath = "\\prdadm037\e$\TOOLS\AzureMonitorAgentClientSetup.msi"
$mmaExistPath = "C:\Program Files\Microsoft Monitoring Agent\Agent\AgentControlPanel.exe"

# Check if the Microsoft Monitoring Agent executable path exists
if (-not (Test-Path -Path $mmaExistPath)) {
    Write-Output "Microsoft Monitoring Agent is not installed. Installing Azure Monitor Agent ..."
    
    # Install Azure Monitor Agent
    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$amaInstallerPath`" /qn" -Wait
    Write-Output "Azure Monitor Agent installation completed."
} else {
    # Run the uninstallation process
    Start-Process -FilePath $uninstallerPath -ArgumentList "/uninstall" -Wait
    
    # Check if uninstallation was successful
    if ($LastExitCode -eq 0) {
        Write-Output "Microsoft Monitoring Agent has been successfully uninstalled."
        
        # Install Azure Monitor Agent
        Write-Output "Installing Azure Monitor Agent..."
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$amaInstallerPath`" /qn" -Wait
        Write-Output "Azure Monitor Agent installation completed."
    } else {
        Write-Output "Failed to uninstall Microsoft Monitoring Agent. Exit code: $($LastExitCode)"
    }
}

