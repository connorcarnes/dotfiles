<#
.SYNOPSIS
    Installs VSCode Extensions.
.DESCRIPTION
    Installs VSCode extensions that aren't automatically installed, or that are only required in certain contexts.
#>
function Install-VSCodeExtension {
    $ToInstall = @()

    if ($env:REMOTE_CONTAINERS) {
        Write-Verbose '$env:REMOTE_CONTAINERS is set'
        $ToInstall += @(
            'redhat.vscode-yaml'
            'naumovs.color-highlight'
            'anseki.vscode-color'
            'github.vscode-github-actions'
            'gitlab.gitlab-workflow'
            'bierner.markdown-emoji'
            'esbenp.prettier-vscode'
            'mechatroner.rainbow-csv'
            'redhat.vscode-yaml'
            'pulumi.pulumi-lsp-client'
        )
    }

    if (Get-Command go -ErrorAction SilentlyContinue) {
        Write-Verbose 'go is installed'
        $ToInstall += @('golang.go')
    }

    if (Get-Command python3 -ErrorAction SilentlyContinue) {
        Write-Verbose 'python3 is installed'
        $ToInstall += @(
            'ms-python.vscode-pylance'
            'ms-python.python'
            'ms-python.debugpy'
        )
    }

    $Commands = @()
    $ToInstall | ForEach-Object {
        if (-not (code --list-extensions | Select-String -Pattern $_)) {
            $Commands += "code --install-extension $_"
        }
    }
    if (-not $Commands) {
        Write-Verbose 'No extensions to install'
    }
    else {
        Write-Verbose "Installing extensions: $Commands"
        pwsh -NoProfile -Command ($Commands -join '; ')
    }
}

# if ($env:REMOTE_CONTAINERS -and ($env:TERM_PROGRAM = "vscode")) {
#     Install-VSCodeExtension
# }