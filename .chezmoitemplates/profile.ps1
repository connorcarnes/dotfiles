<#
    .SYNOPSIS
    Custom PowerShell profile and workstation configuration.

    Author: Connor Carnes

    .NOTES
    There are four default PowerShell profile locations (listed below). Copy the contents of this file to the file located at $Profile.AllUsersAllHosts.
    Create the file if it doesn't exist. For the other locations, confirm the file does not exist or is empty. This will ensure that the profile is loaded from the AllUsersAllHosts location.

    $Profile.AllUsersAllHosts
    $Profile.AllUsersCurrentHost
    $Profile.CurrentUserAllHosts
    $Profile.CurrentUserCurrentHost

    ## Modules
    Install-Module -Name PowerShellGet -Force ; exit
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    Install-Module PSReadLine
    Install-Module PSReadline -AllowPrerelease -Force
    PowerShellGet\Install-Module posh-git -Scope CurrentUser -Force
    Install-Module Microsoft.PowerShell.SecretManagement -Scope CurrentUser -Force
    Install-Module Microsoft.PowerShell.SecretStore -Scope CurrentUser -Force
    Install-Module PSGitHub

    AWS.Tools.Backup
    AWS.Tools.Common
    AWS.Tools.EC2
    AWS.Tools.Installer
    posh-git
    JiraPS
#>



Write-Host 'Loading profile...' -ForegroundColor Cyan
[System.Environment]::SetEnvironmentVariable('CHEZMOI_PATH', $(chezmoi source-path))
Set-PSResourceRepository -Name PSGallery -Trusted

if ($IsLinux -or $IsMacOS) {
    $NixProfiles = '/etc/profile', '~/.profile', '~/.bash_profile', '~/.bashrc', '~/.bash_login', '~/.bash_logout'
    [array]::Reverse($NixProfiles)  # user overrides system
    $NixPathLines = Get-Content $NixProfiles -ErrorAction Ignore | Select-String -Pattern '^\s+PATH='
    $Expressions = @($NixPathLines) -replace '.*PATH\s*=\s*' -replace "^(?<quote>['`"])(.*)(\k<quote>)$", '$1' -split ':' |
        Where-Object { $_ -ne '$PATH' } | Write-Output | Select-Object -Unique
    $PATH = $Expressions | ForEach-Object { $ExecutionContext.InvokeCommand.ExpandString($_) }
    $PATH += $env:PATH -split ':'
    $PATH = $PATH | Select-Object -Unique
    $env:PATH = @($PATH) -ne '' -join ':'
    Remove-Variable PATH, NixProfiles, NixPathLines, Expressions
}

# Module Imports
# $modulesToLoad = @(
#     'posh-git',
#     'Terminal-Icons'
# )
# foreach ($module in $modulesToLoad) {
#     try {
#         Import-Module 'asdf'  -ErrorAction Stop
#     }
#     catch {
#         Write-Error $_
#     }
# }


if (Get-InstalledPSResource -Name 'PSReadLine' -ErrorAction SilentlyContinue) {
    Write-Verbose 'Configuring PSReadLine'
    $Splat = @{
        EditMode            = 'Windows'
        PredictionSource    = 'History'
        Colors              = @{ InlinePrediction = '#2F7004' } # #2F7004 Green
        PredictionViewStyle = 'ListView' # Alternative: InlineView
        MaximumHistoryCount = 10000
        HistorySaveStyle    = 'SaveIncrementally'
    }
    Set-PSReadLineOption @Splat
}

if (Get-Command Install-NerdFont -ErrorAction SilentlyContinue) {
    Install-NerdFont
}


if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    if (Get-Command Install-NerdFont -ErrorAction SilentlyContinue) {
        Install-NerdFont
    }

    $OMPFilePath = "$HOME\.oh-my-posh\custom.omp.json"
    if (Test-Path $File) {
        [System.Environment]::SetEnvironmentVariable('OMP_CONFIG', $OMPFilePath)
        oh-my-posh init pwsh --config  $env:OMP_CONFIG | Invoke-Expression
    }
    else {
        Write-Warning "$env:OMP_CONFIG not found, default theme will be applied"
        oh-my-posh init pwsh | Invoke-Expression
    }
}
else {
    Write-Warning 'oh-my-posh command not found'
}

if (Test-Path $env:CHEZMOI_PATH) {
    $ProfileAsyncScriptBlock = {
        . "$ENV:CHEZMOI_PATH/PSHelpers/Misc.ps1"
        . "$ENV:CHEZMOI_PATH/PSHelpers/Install-VSCodeExtension.ps1"
        Install-VSCodeExtension
    }
    if (Import-Module ProfileAsync -PassThru -ErrorAction Ignore) {
        Import-ProfileAsync $ProfileAsyncScriptBlock
    }
    else {
        . $ProfileAsyncScriptBlock
    }
}
