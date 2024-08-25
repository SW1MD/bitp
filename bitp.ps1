# PowerShell wrapper for bitp.bat

$bitpPath = Join-Path $PSScriptRoot "bitp.bat"

if (Test-Path $bitpPath) {
    $output = & $bitpPath $args
    $output | ForEach-Object {
        if ($_ -match '^CD:(.*)') {
            Set-Location $Matches[1]
        } else {
            Write-Output $_
        }
    }
} else {
    Write-Error "bitp.bat not found at $bitpPath"
}