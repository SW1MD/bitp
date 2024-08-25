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
    PrivateData = @{
        PSData = @{
            Tags = @('bitp', 'utility')
            ProjectUri = 'https://github.com/yourusername/bitp'
        }
    }
}