# Define variables
$installerPath = "\\prdadm001\f$\pve\24x7 Agent\Site24x7WindowsAgent.exe"
$installationKey = "us_d205bf0ef100be20df3518cbb4f33a9b"  # Replace this with your actual installation key
$proxyServer = "wsg.intra.corp.grp"
$proxyPort = "8080"

# Function to install the Site24x7 agent
function Install-Agent {
    Write-Output "Installing Site24x7 agent from $installerPath..."
    if (Test-Path $installerPath) {
        $proxyArgs = "/S /InstallationKey=$installationKey /proxy $proxyServer`:$proxyPort"
        Start-Process -FilePath $installerPath -ArgumentList $proxyArgs -Wait
        if ($LASTEXITCODE -eq 0) {
            Write-Output "Installation completed successfully."
        } else {
            Write-Output "Installation failed with exit code $LASTEXITCODE."
            exit 1
        }
    } else {
        Write-Output "Installer not found at $installerPath."
        exit 1
    }
}

# Main script execution
Install-Agent
