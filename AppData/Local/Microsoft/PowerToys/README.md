# PowerToys Config File Paths

If there's a PowerToys module I like I'll configure it through the UI and have chezmoi manage the relevant file(s).

## Root settings.json

`settings.json` in root of this folder goes in `%HomePath%\AppData\Local\Microsoft\PowerToys`.

## Backup path (all settings, .ptb file)

`%HomePath%\Documents\PowerToys\Backup`

## Module settings.json

Base path is `%HomePath%\AppData\Local\Microsoft\PowerToys\`. Default module directory names match what's in this folder e.g. `%HomePath%\AppData\Local\Microsoft\PowerToys\PowerToys Run`, `%HomePath%\AppData\Local\Microsoft\PowerToys\RegistryPreview`.

## Links

- [ZoomIt Demo Type](https://www.youtube.com/watch?v=i5j0SzmhxhU)
- [PowerToys DSC](https://learn.microsoft.com/en-us/windows/powertoys/dsc-configure)

## Notes

I created `Keyboard Manager/macprofile.json` when I was daily driving mac for work and wanted to use the same hotkeys on mac and windows.