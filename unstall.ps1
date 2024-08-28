# List of target machine hostnames or IP addresses
$targetMachines = @("hostname1", "hostname2", ...)

# Credentials for remote connection (replace with your own)
$credentials = Get-Credential

# Function to uninstall Sophos products on a remote machine
function Uninstall-SophosProducts {
    param (
        [string]$ComputerName,
        [pscredential]$Credentials
    )

    # Construct the remote session
    $session = New-PSSession -ComputerName $ComputerName -Credential $Credentials
    
    # Uninstall Sophos Anti-Virus
    $SophosAVUninstallString = "C:\Program Files\Sophos\Sophos Anti-Virus\uninstall.exe"
    if (Test-Path $SophosAVUninstallString) {
        Invoke-Command -Session $session -ScriptBlock {
            Start-Process -FilePath $using:SophosAVUninstallString -ArgumentList "/quiet" -Wait
        }
    }

    # Uninstall Sophos AutoUpdate
    $SophosAutoUpdateUninstallString = "C:\Program Files\Sophos\AutoUpdate\ALsvc.exe"
    if (Test-Path $SophosAutoUpdateUninstallString) {
        Invoke-Command -Session $session -ScriptBlock {
            Start-Process -FilePath $using:SophosAutoUpdateUninstallString -ArgumentList "/quit" -Wait
        }
    }

    # Uninstall Sophos Endpoint Defense
    $SophosEPUninstallString = "C:\Program Files\Sophos\Endpoint Defense\uninstall.exe"
    if (Test-Path $SophosEPUninstallString) {
        Invoke-Command -Session $session -ScriptBlock {
            Start-Process -FilePath $using:SophosEPUninstallString -ArgumentList "/quiet" -Wait
        }
    }

    # Uninstall Sophos Management System (Sophos Central)
    # Modify this according to how Sophos Central is installed and uninstalled
    # Example:
    # $SophosCentralUninstallString = "C:\Program Files\Sophos\Central\uninstall.exe"
    # if (Test-Path $SophosCentralUninstallString) {
    #     Invoke-Command -Session $session -ScriptBlock {
    #         Start-Process -FilePath $using:SophosCentralUninstallString -ArgumentList "/quiet" -Wait
    #     }
    # }

    # Close the remote session
    Remove-PSSession -Session $session
}

# Execute uninstallation on multiple machines in parallel
foreach ($machine in $targetMachines) {
    Start-Job -ScriptBlock {
        param (
            [string]$ComputerName,
            [pscredential]$Credentials
        )
        Uninstall-SophosProducts -ComputerName $ComputerName -Credentials $Credentials
    } -ArgumentList $machine, $credentials
}

# Wait for all jobs to complete
Get-Job | Wait-Job

# Retrieve job results
Get-Job | Receive-Job

# Clean up jobs
Get-Job | Remove-Job
