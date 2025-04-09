#! /usr/bin/pwsh

$RequiredResources = @{
    'Microsoft.PowerShell.PSResourceGet'    = @{version = '[0.0.0.1, ]' }
    'Microsoft.WinGet.Configuration'        = @{version = '[0.0.0.1, ]' }
    'Microsoft.PowerShell.SecretManagement' = @{version = '[0.0.0.1, ]' }
    'Microsoft.PowerShell.SecretStore'      = @{version = '[0.0.0.1, ]' }
    'posh-git'                              = @{version = '[0.0.0.1, ]' }
    'PSReadLine'                            = @{version = '[0.0.0.1, ]' ; PreRelease = 'true' ; Reinstall = 'true' }
    'Pester'                                = @{version = '[0.0.0.1, ]' }
    'Terminal-Icons'                        = @{version = '[0.0.0.1, ]' }
    'PSScriptAnalyzer'                      = @{version = '[0.0.0.1, ]' }
    'InvokeBuild'                           = @{version = '[0.0.0.1, ]' }
    'SecretManagement.Warden'               = @{version = '[0.0.0.1, ]' }
    'ProfileAsync'                          = @{version = '[0.0.0.1, ]' }
}
$ToInstall = $RequiredResources.Keys | Where-Object { -not (Get-InstalledPSResource -Name $_ -ErrorAction 'SilentlyContinue') }
$ToSkip = $RequiredResources.Keys | Where-Object { $ToInstall -notcontains $_ }
$ToSkip | ForEach-Object {
    if ($RequiredResources.$_.Reinstall) {
        Write-Verbose "$_ marked for reinstallation"
    }
    else {
        $RequiredResources.Remove($_)
    }
}
if (-not $ToInstall) {
    Write-Verbose 'No modules to install'
}
else {
    Write-Verbose "Installing modules: $($ToInstall -join ', ')"
    Install-PSResource -RequiredResource $RequiredResources
}