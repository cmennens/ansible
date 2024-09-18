# PowerShell script to enable SSH on Windows 11 Pro

# Function to check and install OpenSSH components
function Install-OpenSSH {
    param (
        [string]$component
    )
    
    # Check if the OpenSSH component is installed
    $installed = Get-WindowsCapability -Online | Where-Object { $_.Name -like "*$component*" -and $_.State -eq "Installed" }

    # Install the component if it's not installed
    if (-not $installed) {
        Write-Host "Installing $component..."
        Add-WindowsCapability -Online -Name $component
    } else {
        Write-Host "$component is already installed."
    }
}

# Install OpenSSH Client and Server
Install-OpenSSH -component "OpenSSH.Client~~~~0.0.1.0"
Install-OpenSSH -component "OpenSSH.Server~~~~0.0.1.0"

# Enable and start the SSH server service
Write-Host "Enabling and starting the SSH server service..."
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

# Allow SSH traffic through the firewall
Write-Host "Allowing SSH through the firewall..."
New-NetFirewallRule -Name "SSH" -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22

Write-Host "SSH is now enabled on this machine."
