oh-my-posh init pwsh --config 'https://raw.githubusercontent.com/harikesh409/dotfiles/master/oh-my-posh/hari.omp.json' | Invoke-Expression

# PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadLineOption -EditMode Windows

# Icons
Import-Module -Name Terminal-Icons

# Fzf
# https://github.com/kelleyma49/PSFzf?tab=readme-ov-file#reverse-search-through-psreadline-history-default-chord-ctrlr
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

## Alias for podman
# Set-Alias -Name docker -Value podman
