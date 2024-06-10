ECHO Installing apps

ECHO Configure chocolatey
choco feature enable -n allowGlobalConfirmation

choco install chocolateygui

choco install googlechrome
choco install brave

choco install nodejs.install
choco install jdk8
choco install python3
choco install maven

choco install vscode.install
choco install intellijidea-community
choco install eclipse
choco install notepadplusplus.install
choco install git.install
choco install postman
choco install soapui

choco install ccleaner

choco install zig
choco install neovim
choco install zoom
choco install 7zip.install
choco install vlc

choco feature disable -n allowGlobalConfirmation
