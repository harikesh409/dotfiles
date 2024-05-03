# Installation Command
## Admin Mode
Run powershell in elevated mode and execute the below command
 ```ps 
 powershell -ExecutionPolicy Bypass -File .\choco-dev-setup.ps1
 ```
## Non-Admin Mode
```ps
Set-ExecutionPolicy Bypass -Scope Process -Force;
.\ChocolateyInstallNonAdmin.ps1
```
