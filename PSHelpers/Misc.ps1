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
            Write-Warning "$Font is not installed. Installing it now via: oh-my-posh font install $FontLibrary"
            oh-my-posh font install $FontLibrary
        }
    }
}

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

function Enable-FileExecution {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = 'Path to file.')]
        [Alias('PSPath')]
        [ValidateNotNullOrEmpty()]
        [string]$FilePath
    )
    # chmod a+x equivalent
    $ACL = Get-Acl $FilePath
    $Permission = 'Everyone', 'Execute', 'Allow'
    $Rule = [System.Security.AccessControl.FileSystemAccessRule]::new($permission)
    $ACL.AddAccessRule($Rule)
    Set-Acl -Path $FilePath -AclObject $ACL
}

# Get-PwshProfilePaths
function Get-PwshProfilePaths {
    $Profile.AllUsersAllHosts
    $Profile.AllUsersCurrentHost
    $Profile.CurrentUserAllHosts
    $Profile.CurrentUserCurrentHost
}

# posh-git prompt
# function prompt {
#     <#
#         .SYNOPSIS
#         posh-git prompt.
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