# Bitp PowerShell Module

function Invoke-Bitp {
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Arguments
    )

    $bitpPath = Join-Path $PSScriptRoot "bitp.bat"

    if (Test-Path $bitpPath) {
        $output = & $bitpPath $Arguments
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
}

Set-Alias -Name bitp -Value Invoke-Bitp

Export-ModuleMember -Function Invoke-Bitp -Alias bitp