If (Test-Path -Path "$env:ProgramData\Chocolatey") {
  Install-ChocoPackagesFromFile
} Else {
    ## Installing Choclatey in non-admin mode
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    .\ChocolateyInstallNonAdmin.ps1
    Install-ChocoPackagesFromFile
}

function Install-ChocoPackagesFromFile {
    param (
        [string]$filePath = "${PWD}\choco-dev-setup.ps1"
    )

    # Check if the file exists
    if (!(Test-Path -Path $filePath)) {
        Write-Output "File '$filePath' not found."
        return
    }
    # Read each line as a command and execute it
    $commands = Get-Content -Path $filePath | Where-Object { $_ -match "^choco install" }

    foreach ($command in $commands) {
        Write-Output "Executing: $command"
        Invoke-Expression $command
    }
}

## Configure oh-my-posh theme
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\${PWD}\..\oh-my-posh\hari.omp.json" | Invoke-Expression

# Linking nvim config
New-Item -Path ${HOME}\AppData\Local\nvim -ItemType Junction -Target ${PWD}\..\nvim

# Linking git-cz
New-Item -Path ${HOME}\.czrc -ItemType SymbolicLink -Target ${PWD}\..\.czrc
