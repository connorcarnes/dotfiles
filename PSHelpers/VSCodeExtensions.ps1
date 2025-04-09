$ChezmoiPath = $(chezmoi source-path)
$ToInstall = (Get-Content "$ChezmoiPath/.extensions.json" | ConvertFrom-Json)
$Installed = $(code --list-extensions)

$ToInstall | ForEach-Object {
    if ($_ -in $Installed) {
        Write-Verbose "Extension $_ already installed"
    }
    else {
        Write-Verbose "Installing extension $_"
        $null = code --install-extension $_
    }
}

# $ToSkip = @(
#     'terrastruct.d2'
#     'ms-vscode.remote-explorer'
#     'ms-python.debugpy'
#     'ms-python.python'
#     'ms-vscode-remote.remote-ssh-edit'
#     'docker.docker'
#     'ms-vscode-remote.remote-wsl'
#     'ms-vscode.remote-server'
# )
