# Check if the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script requires administrative privileges. Please run the script as an administrator."
    Exit
}

# Uninstall Microsoft Monitoring Agent (MMA)
$mmaPath = "$env:ProgramFiles\Microsoft Monitoring Agent"
if (Test-Path $mmaPath) {
    Write-Output "Uninstalling Microsoft Monitoring Agent (MMA)..."
    try {
        & "$mmaPath\Agent\HealthService.exe" -uninstall
        Remove-Item -Path $mmaPath -Recurse -Force
        Write-Output "Microsoft Monitoring Agent (MMA) has been uninstalled successfully."
    } catch {
        Write-Error "Failed to uninstall MMA: $_"
        Exit 1
    }
} else {
    Write-Output "Microsoft Monitoring Agent (MMA) is not installed on this machine."
}

# Install Azure Monitor Agent (AMA)
Write-Output "Installing Azure Monitor Agent (AMA)..."
try {
    $amaInstallerUrl = "https://aka.ms/azmon-win"
    $amaInstallerPath = "$env:TEMP\AzureMonitorAgentSetup.exe"
    Invoke-WebRequest -Uri $amaInstallerUrl -OutFile $amaInstallerPath
    Start-Process -FilePath $amaInstallerPath -ArgumentList "/quiet" -Wait
    Write-Output "Azure Monitor Agent (AMA) has been installed successfully."
} catch {
    Write-Error "Failed to install Azure Monitor Agent (AMA): $_"
    Exit 1
}
