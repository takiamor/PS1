# Define the MSI path
$amaInstallerPath = "\\prdadm037\e$\TOOLS\AzureMonitorAgentClientSetup.msi"

# Install Azure Monitor Agent
Write-Output "Installing Azure Monitor Agent..."
$process = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$amaInstallerPath`" /qn" -Wait -PassThru

# Capture the exit code
$exitCode = $process.ExitCode

if ($exitCode -eq 0) {
    Write-Output "Successfully installed the Azure Monitor Agent."
} else {
    Write-Output "Failed to install the Azure Monitor Agent. Exit code: $exitCode"
}
