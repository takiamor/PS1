# Function to run an executable and capture output
function Run-Executable {
    param (
        [string]$exePath,
        [string[]]$arguments = @()
    )
    
    try {
        $process = Start-Process -FilePath $exePath -ArgumentList $arguments -NoNewWindow -Wait -PassThru
        if ($process.ExitCode -eq 0) {
            Write-Output "$exePath executed successfully."
        } else {
            Write-Output "Failed to execute $exePath. Exit Code: $($process.ExitCode)"
        }
    } catch {
        Write-Output "Failed to execute $exePath. Error: $_"
    }
}

# Function to uninstall a product
function Uninstall-Product {
    param (
        [string]$productName
    )
    
    $product = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*$productName*"}
    if ($product) {
        try {
            $product.Uninstall() | Out-Null
            Write-Output "$productName uninstalled successfully."
        } catch {
            Write-Output "Failed to uninstall $productName. Error: $_"
        }
    } else {
        Write-Output "$productName is not installed."
    }
}

# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "Script is not running as administrator. Please run as administrator."
    exit
}

# Attempt to disable Tamper Protection
try {
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Sophos Endpoint Defense\TamperProtection\Config" -Name "SEDEnabled" -Value 0
    Write-Output "Tamper Protection disabled."
} catch {
    Write-Output "Failed to disable Tamper Protection. Error: $_"
}

# Uninstall Sophos Anti-Virus
Uninstall-Product "Sophos Anti-Virus"

# Uninstall Sophos AutoUpdate
Uninstall-Product "Sophos AutoUpdate"

# Uninstall Sophos Endpoint Defense using SEDuninstall.exe
$sedUninstallPath = "C:\Program Files\Sophos\Endpoint Defense\SEDuninstall.exe"
if (Test-Path $sedUninstallPath) {
    try {
        Run-Executable -exePath $sedUninstallPath
    } catch {
        Write-Output "Failed to uninstall Sophos Endpoint Defense. Error: $_"
    }
} else {
    Write-Output "SEDuninstall.exe not found at $sedUninstallPath"
}

# Uninstall Sophos Management System (Sophos Central)
Uninstall-Product "Sophos Remote Management System"

Write-Output "Uninstallation process completed."
