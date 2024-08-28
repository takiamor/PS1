# Define variables
$proxyServer = "wsg.intra.corp.grp"
$proxyPort = "8080"

# Function to configure proxy for Site24x7 agent
function Configure-Proxy {
    Write-Output "Configuring proxy for Site24x7 agent..."
    $site24x7ConfigFile = "C:\Program Files (x86)\Site24x7\WinAgent\conf\winagent.conf"
    
    if (Test-Path $site24x7ConfigFile) {
        # Replace existing proxy settings or add new ones
        (Get-Content $site24x7ConfigFile) |
        ForEach-Object {$_ -replace 'proxy_host\s*=\s*\S+', "proxy_host = $proxyServer"} |
        ForEach-Object {$_ -replace 'proxy_port\s*=\s*\S+', "proxy_port = $proxyPort"} |
        Set-Content $site24x7ConfigFile
        Write-Output "Proxy configured successfully."
    } else {
        Write-Output "Site24x7 configuration file not found at $site24x7ConfigFile."
        exit 1
    }
}

# Main script execution
Configure-Proxy
