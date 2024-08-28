# Define variables
$installerPath = "C:\Users\ADMTCHI\Desktop\MMASetup-AMD64.exe"
$workspaceId = "56fa0a41-0e96-4282-b15c-8f2c0f231671"
$workspaceKey = "NhzynfdsOD0CwpWPnXTb4FVK7FVbgxI4/JSj6f4y2Pwedhua3WISLfWgoS5wlw8sfR0kV+LQb2+FsMnZ+pd3+g=="

# Execute installation
$process = Start-Process -FilePath $installerPath -ArgumentList "/quiet", "/norestart" -Wait -PassThru

# Check if installation was successful
if ($process.ExitCode -eq 0) {
    Write-Host "Microsoft Monitoring Agent installation completed successfully."
    
    # Configure MMA with workspace ID and key
    $regPath = "HKLM:\SOFTWARE\Microsoft\Microsoft Monitoring Agent"
    New-ItemProperty -Path $regPath -Name "WorkspaceId" -Value $workspaceId -PropertyType String -Force
    New-ItemProperty -Path $regPath -Name "WorkspaceKey" -Value $workspaceKey -PropertyType String -Force

    # Start the MMA service
    Start-Service -Name "HealthService"
    Write-Host "Microsoft Monitoring Agent configuration completed successfully."
} else {
    Write-Host "Microsoft Monitoring Agent installation failed. Exit code: $($process.ExitCode)"
}
