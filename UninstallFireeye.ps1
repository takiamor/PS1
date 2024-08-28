# Define the software name
$softwareName = "FireEye"

# Get the software details
$software = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%$softwareName%'"

# Check if the software is found
if ($software) {
    foreach ($app in $software) {
        Write-Host "Uninstalling: $($app.Name)"
        $app.Uninstall()
        Write-Host "Uninstallation of $($app.Name) complete."
    }
} else {
    Write-Host "No software found with name like $softwareName"
}
