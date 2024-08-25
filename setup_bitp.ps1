# Setup script for bitp tool

# Define the destination directory (root of C: drive)
$destDir = "C:\bitp"

# Create the destination directory if it doesn't exist
if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir | Out-Null
}

# Copy bitp.py and bitp.bat to the destination directory
Copy-Item "bitp.py" -Destination $destDir
Copy-Item "bitp.bat" -Destination $destDir

# Add the destination directory to the system PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "Machine")
if ($currentPath -notlike "*$destDir*") {
    $newPath = "$currentPath;$destDir"
    [Environment]::SetEnvironmentVariable("PATH", $newPath, "Machine")
    Write-Host "Added $destDir to system PATH"
} else {
    Write-Host "$destDir is already in system PATH"
}

Write-Host "bitp tool has been set up in $destDir and added to system PATH"
Write-Host "Please restart your command prompt or PowerShell session for the changes to take effect"