#!PS
#timeout=9000000
# Save the current execution policy
$currentPolicy = Get-ExecutionPolicy

# Temporarily allow script execution
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

# Define the URL for the MSI file
$msiUrl = "https://github.com/LITechAdvisors/anyconnectvpn/raw/refs/heads/main/vpn.msi"

# Create a temporary directory
$tempDir = New-Item -ItemType Directory -Path (Join-Path -Path $env:TEMP -ChildPath ([System.Guid]::NewGuid().ToString()))

# Define the path to save the MSI file
$msiPath = Join-Path -Path $tempDir.FullName -ChildPath "vpn.msi"

# Download the MSI file
Write-Host "Downloading MSI..."
Invoke-WebRequest -Uri $msiUrl -OutFile $msiPath -UseBasicParsing

# Define MSI silent installation parameters
# Replace `/qn` and `/norestart` with the appropriate parameters as per the documentation if different
$msiExecArgs = "/i `"$msiPath`" /qn /norestart"

# Install the MSI silently
Write-Host "Installing MSI..."
Start-Process -FilePath "msiexec.exe" -ArgumentList $msiExecArgs -Wait -NoNewWindow

# Check the exit code of the installation
if ($LASTEXITCODE -ne 0) {
    Write-Error "Installation failed with exit code $LASTEXITCODE."
    Exit $LASTEXITCODE
}

# Clean up the temporary directory
Write-Host "Cleaning up..."
Remove-Item -Path $tempDir.FullName -Recurse -Force

# Restore the original execution policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy $currentPolicy

Write-Host "Installation completed successfully."
