# Define the name of the Trend Micro product to uninstall
$trendMicroProductName = "Trend Micro Deep Security Agent"

# Get the installed Trend Micro product
$trendMicroProduct = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name LIKE '%$trendMicroProductName%'"

if ($trendMicroProduct) {
    # Uninstall the Trend Micro product
    $uninstallResult = $trendMicroProduct.Uninstall()

    if ($uninstallResult.ReturnValue -eq 0) {
        Write-Host "$trendMicroProductName has been uninstalled."
    } else {
        Write-Host "Failed to uninstall $trendMicroProductName. Return code: $($uninstallResult.ReturnValue)"
    }
} else {
    Write-Host "Trend Micro product '$trendMicroProductName' not found."
}
