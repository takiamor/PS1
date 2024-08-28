$app = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -eq 'Microsoft Monitoring Agent'}

if ($app) {
    $uninstallResult = $app.Uninstall()
    $var = $uninstallResult.ReturnValue
    if ($var -eq 0) {
        Write-Host "Successfully uninstalled."
    } else {
        Write-Host "Uninstallation failed with return value: $var"
        Write-Host "Uninstall output: $uninstallResult"
    }
} else {
    Write-Host "Microsoft Monitoring Agent is not installed."
}
