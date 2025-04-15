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