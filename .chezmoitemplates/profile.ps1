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

[System.Environment]::SetEnvironmentVariable('CHEZMOI_PATH', $(chezmoi source-path))

Write-Host 'Loading profile...' -ForegroundColor Cyan

Set-PSResourceRepository -Name PSGallery -Trusted

# Module Imports
$modulesToLoad = @(
    'posh-git',
    'Terminal-Icons'
)
foreach ($module in $modulesToLoad) {
    try {
        Import-Module $module -ErrorAction Stop
    }
    catch {
        Write-Host "Module $module has failed to load." -ForegroundColor DarkRed
    }
}


# PSReadline
$Splat = @{
    EditMode            = 'Windows'
    #PredictionSource    = 'History'
    PredictionSource    = 'HistoryAndPlugin'
    Colors              = @{ InlinePrediction = '#2F7004' } #green
    PredictionViewStyle = 'ListView' #you may prefer InlineView
    MaximumHistoryCount = 10000
    HistorySaveStyle    = 'SaveIncrementally'
}
Set-PSReadLineOption @Splat
# $PSReadlineOptions = Get-PSReadLineOption
# $PSReadlineOptions.HistorySavePath
# $PSReadlineOptions.MaximumHistoryCount
# $PSReadlineOptions.HistorySaveStyle
# $PSReadlineOptions.PredictionSource

# Module Logging
# has to be enabled in config file and per session:
# https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_logging_windows
# Need to revisit this, not sure if it's compatible with PSResourceGet
# For now I removed relevant config from "$PSHOME\powershell.config.json":
# 'ModuleLogging': {
#     'EnableModuleLogging': true,
#     'ModuleNames': [
#     'PSReadLine', # Found with Get-Module
#     'Microsoft.WinGet.Client', # Found with Get-InstalledPsResource, missing LogPipelineExecutionDetail
#     ]
# }
#
# $PwshConfigJSON = Get-Content "$PSHOME\powershell.config.json" | ConvertFrom-Json
# $PwshConfigJSON.ModuleLogging.ModuleNames |
#     ForEach-Object {
#         $module = Get-Module -Name $_
#         if ($module) {
#             Write-Verbose "Enabling module logging: $($module.name)"
#             $module.LogPipelineExecutionDetails = $true
#         }
#     }
# Get-Syntax
function Get-Syntax {
    <#
        .SYNOPSIS
        Get beautiful syntax for any cmdlet
    #>
    [CmdletBinding()]
    param (
        $Command,
        [switch]
        $PrettySyntax
    )
    $check = Get-Command -Name $Command
    $params = @{
        Name   = if ($check.CommandType -eq 'Alias') {
            Get-Command -Name $check.Definition
        }
        else {
            $Command
        }
        Syntax = $true
    }
    $pretty = $true
    if ($pretty -eq $true) {
        (Get-Command @params) -replace '(\s(?=\[)|\s(?=-))', "`r`n "
    }
    else {
        Get-Command @params
    }
}


# Get-PwshProfilePaths
function Get-PwshProfilePaths {
    $Profile.AllUsersAllHosts
    $Profile.AllUsersCurrentHost
    $Profile.CurrentUserAllHosts
    $Profile.CurrentUserCurrentHost
}


# Custom prompt function
# function prompt {
#     <#
#         .SYNOPSIS
#         Custom prompt function.
#         .EXAMPLE
#         [2022-JUL-30 21:18][..project-starters\aws\aws-backup-automation][main ≡]
#         >>
#     #>
#     $global:promptDateTime = [datetime]::Now
#     $Global:promptDate = $global:promptDateTime.ToString('yyyy-MMM-dd').ToUpper()
#     $Global:promptTime = $global:promptDateTime.ToString('HH:mm')

#     # truncate the current location if too long
#     $currentDirectory = $executionContext.SessionState.Path.CurrentLocation.Path
#     $consoleWidth = [Console]::WindowWidth
#     $maxPath = [int]($consoleWidth / 4.5)
#     if ($currentDirectory.Length -gt $maxPath) {
#         $currentDirectory = '..' + $currentDirectory.SubString($currentDirectory.Length - $maxPath)
#     }
#     $global:promptPath = $currentDirectory

#     $InGitRepo = Write-VcsStatus
#     if ($InGitRepo) {
#         Write-Host "[$global:promptDate $global:promptTime]" -ForegroundColor Green -NoNewline
#         Write-Host "[$global:promptPath]" -ForegroundColor Magenta -NoNewline
#         Write-Host $InGitRepo.Trim() -NoNewline
#         "`r`n>>"
#     }
#     else {
#         Write-Host "[$global:promptDate $global:promptTime]" -ForegroundColor Green -NoNewline
#         Write-Host "[$global:promptPath]" -ForegroundColor Magenta -NoNewline
#         "`r`n>>"
#     }
# }

# chmod a+x equivalent
# $acl = Get-Acl .\install.sh
# $permission = 'Everyone', 'Execute', 'Allow'
# $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
# $acl.AddAccessRule($accessRule)
# Set-Acl .\install.sh $acl

function Install-NerdFont {
    [CmdletBinding()]
    param (
        [string]$Font = 'MesloLGM Nerd Font',
        [string]$FontLibrary = 'meslo'
    )
    $FontInstalled = $false
    if ($IsLinux) {
        $FontPaths = @(
            '/usr/share/fonts'
            '~/.local/share/fonts'
        )
        foreach ($Path in $FontPaths) {
            $Fonts = (Get-ChildItem $Path -ErrorAction SilentlyContinue).name
            $FontInstalled = [bool]($Fonts -match $Font)
            if ($FontInstalled -eq $true) {
                Write-Verbose "$Font is installed."
                break
            }
        }
    }
    if ($IsMacOS) {
        Write-Warning 'Update profile function Install-NerdFont to support macos'
    }
    if ($IsWindows) {
        $FontRegKeys = @(
            'HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts'
            'HKCU:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts'
        )
        foreach ($Key in $FontRegKeys) {
            $Fonts = (Get-Item -Path $Key).Property
            $FontInstalled = [bool]($Fonts -match $Font)
            if ($FontInstalled -eq $true) {
                Write-Verbose "$Font is installed."
                break
            }
        }
        if (-not $FontInstalled) {
            Write-Warning "$Font is not installed. Install it with: oh-my-posh font install $FontLibrary"
        }
    }
}
Install-NerdFont

$OhMyPwshConfig = "$HOME\.oh-my-posh\custom.omp.json"
if ($OhMyPwshConfig) {
    oh-my-posh init pwsh --config  $OhMyPwshConfig | Invoke-Expression
}
else {
    Write-Warning "$OhMyPwshConfig not found, default theme will be applied"
    oh-my-posh init pwsh | Invoke-Expression
}

$AsyncScriptblock = {
    . $ENV:CHEZMOI_PATH/PSHelpers/InstallModules.ps1
    . $ENV:CHEZMOI_PATH/PSHelpers/VSCodeExtensions.ps1
}
Import-ProfileAsync $AsyncScriptblock