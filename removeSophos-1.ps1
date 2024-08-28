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

# Uninstall Sophos Anti-Virus
$antiVirus = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Sophos Anti-Virus*"}
if ($antiVirus) {
    try {
        $antiVirus.Uninstall() | Out-Null
        Write-Output "Sophos Anti-Virus uninstalled successfully."
    } catch {
        Write-Output "Failed to uninstall Sophos Anti-Virus. Error: $_"
    }
} else {
    Write-Output "Sophos Anti-Virus is not installed."
}

# Uninstall Sophos AutoUpdate
$autoUpdate = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Sophos AutoUpdate*"}
if ($autoUpdate) {
    try {
        $autoUpdate.Uninstall() | Out-Null
        Write-Output "Sophos AutoUpdate uninstalled successfully."
    } catch {
        Write-Output "Failed to uninstall Sophos AutoUpdate. Error: $_"
    }
} else {
    Write-Output "Sophos AutoUpdate is not installed."
}

# Uninstall Sophos Endpoint Defense using SEDuninstall.exe
$sedUninstallPath = "C:\Program Files\Sophos\Endpoint Defense\SEDuninstall.exe"
if (Test-Path $sedUninstallPath) {
    try {
        Start-Process -FilePath $sedUninstallPath -Wait -NoNewWindow
        Write-Output "Sophos Endpoint Defense uninstalled successfully."
    } catch {
        Write-Output "Failed to uninstall Sophos Endpoint Defense. Error: $_"
    }
} else {
    Write-Output "SEDuninstall.exe not found at $sedUninstallPath"
}

# Uninstall Sophos Management System (Sophos Central)
# Note: Modify this section based on the specific name of the Sophos Management System product
$managementSystem = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Sophos Remote Management System*"}
if ($managementSystem) {
    try {
        $managementSystem.Uninstall() | Out-Null
        Write-Output "Sophos Management System uninstalled successfully."
    } catch {
        Write-Output "Failed to uninstall Sophos Management System. Error: $_"
    }
} else {
    Write-Output "Sophos Management System is not installed."
}