function Install-VSCodeExtension {
    Write-Verbose 'Installing VSCode extensions'
}
# $ChezmoiPath = $(chezmoi source-path)
# $ToInstall = (Get-Content "$ChezmoiPath/.extensions.json" | ConvertFrom-Json)
# $Installed = $(code --list-extensions)

# $ToInstall | ForEach-Object {
#     if ($_ -in $Installed) {
#         Write-Verbose "Extension $_ already installed"
#     }

#     else {
#         Write-Verbose "Installing extension $_"
#         $null = code --install-extension $_
#     }
# }


