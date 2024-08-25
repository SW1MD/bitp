# Bitp Installer Script

# Define the installation directory
$installDir = "$env:USERPROFILE\Bitp"

# Create the installation directory if it doesn't exist
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
}

# Define the URLs for the required files
$files = @{
    "bitp.py" = "https://raw.githubusercontent.com/yourusername/bitp/main/bitp.py"
    "bitp.bat" = "https://raw.githubusercontent.com/yourusername/bitp/main/bitp.bat"
}

# Download the files
foreach ($file in $files.GetEnumerator()) {
    $outFile = Join-Path $installDir $file.Key
    Invoke-WebRequest -Uri $file.Value -OutFile $outFile
}

# Create a PowerShell script to wrap bitp.bat
$wrapperContent = @"
function Invoke-Bitp {
    param(
        [Parameter(ValueFromRemainingArguments=`$true)]
        [string[]]`$Arguments
    )

    `$bitpPath = Join-Path "$installDir" "bitp.bat"

    if (Test-Path `$bitpPath) {
        `$output = & `$bitpPath `$Arguments
        `$output | ForEach-Object {
            if (`$_ -match '^CD:(.*)') {
                Set-Location `$Matches[1]
            } else {
                Write-Output `$_
            }
        }
    } else {
        Write-Error "bitp.bat not found at `$bitpPath"
    }
}

Set-Alias -Name bitp -Value Invoke-Bitp
"@

$wrapperPath = Join-Path $installDir "Bitp.psm1"
Set-Content -Path $wrapperPath -Value $wrapperContent

# Create a module manifest
$manifestContent = @"
@{
    RootModule = 'Bitp.psm1'
    ModuleVersion = '1.0'
    GUID = 'f1f1b7e0-5f1a-4f1e-9f1a-1f1e9f1a1f1e'
    Author = 'YourName'
    Description = 'Bitp PowerShell Module'
    PowerShellVersion = '5.0'
    FunctionsToExport = @('Invoke-Bitp')
    CmdletsToExport = @()
    VariablesToExport = @()
    AliasesToExport = @('bitp')
}
"@

$manifestPath = Join-Path $installDir "Bitp.psd1"
Set-Content -Path $manifestPath -Value $manifestContent

# Add the installation directory to the PowerShell module path
$currentValue = [Environment]::GetEnvironmentVariable("PSModulePath", "User")
if ($currentValue -notlike "*$installDir*") {
    $newValue = $currentValue + [IO.Path]::PathSeparator + $installDir
    [Environment]::SetEnvironmentVariable("PSModulePath", $newValue, "User")
}

# Add the installation directory to the system PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*$installDir*") {
    $newPath = $currentPath + [IO.Path]::PathSeparator + $installDir
    [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
}

Write-Host "Bitp has been installed successfully!"
Write-Host "Please restart your PowerShell session or run 'Import-Module Bitp' to start using it."
Write-Host "You can now use the 'bitp' command from any location in PowerShell."