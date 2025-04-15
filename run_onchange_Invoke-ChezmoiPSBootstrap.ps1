#! /usr/bin/pwsh

<#
.SYNOPSIS
    Installs PowerShell modules.
.DESCRIPTION
    This script is meant to run when an environment is being initialized (e.g. chezmoi init --apply), or if chezmoi apply is run
    and the file contents have changed since the previous run.
.LINK
    https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/
.LINK
    https://www.chezmoi.io/reference/commands/init/
#>

function Invoke-ChezmoiPSBootstrap {
    $PSScriptPath = (Get-Item $MyInvocation.ScriptName).FullName
    $Commands = @()
    $PSResources = @{
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
    $ToInstall = $PSResources.Keys |
        Where-Object {
            -not (Get-InstalledPSResource -Name $_ -ErrorAction 'SilentlyContinue') -or
            $PSResources[$_].Reinstall -eq $true
        }
    $ToInstall | ForEach-Object {
        $Name = $_
        $Version = $PSResources[$_].version
        $Reinstall = $PSResources[$_].Reinstall
        $PreRelease = $PSResources[$_].PreRelease
        $Command = "Install-PSResource -Name $Name -Version '$Version'"
        if ($Reinstall) { $Command += ' -Reinstall' }
        if ($PreRelease) { $Command += ' -Prerelease' }
        #$Commands += "try { $Command -ErrorAction Stop } catch { Write-Error -Message '$Error[] $($PSScriptPath)' }"
        $Commands += "try { $Command -ErrorAction Stop } catch { `$msg = '$($PSScriptPath) ' + `$_ ; Write-Error -Message `$msg}"
    }
    if (-not $Commands) {
        Write-Verbose 'No modules to install'
    } else {
        Write-Verbose "Installing modules: $Commands"
        pwsh -NoProfile -Command ($Commands -join '; ')
    }
}

Invoke-ChezmoiPSBootstrap