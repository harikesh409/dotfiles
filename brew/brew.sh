
sudo -v

# Install Homebrew
# export HOMEBREW_NO_INSTALL_FROM_API=1
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ($HOME)/.zprofile
# eval "$(/opt/homebrew/bin/brew shellenv)"

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

brew install wget
brew install 1password-cli
brew install adobe-acrobat-reader
brew install openjdk@8
brew install openjdk@11
brew install openjdk@17
brew install appcleaner
brew install awscli
brew install azure-cli
brew install azure-data-studio
brew install brave-browser
brew install cakebrew
brew install colima
brew install dbeaver-community
brew install docker
brew install docker-completion
brew install docker-compose
brew install docker-credential-helper
brew install eul
brew install fd
brew install fliqlo
brew install fluxctl
brew install fzf
brew install gh
brew install gimp
brew install git
brew install git-credential-manager-core
brew install git-extras
brew install github
brew install --cask grammarly-desktop
brew install google-chrome
brew install helm
brew install helmfile
brew install intellij-idea
brew install iterm2
brew install itsycal
brew install jenv

## Jenv Plugins
jenv enable-plugin export
jenv enable-plugin maven


brew install jpeg
brew install jpeg-turbo
brew install jq
brew install k9s
brew install keka
brew install keybase
brew install kubectx
brew install kubernetes-cli
brew install libreoffice
brew install maven
brew install neovim
brew install node
brew install notion
brew install nvm
brew install openssl@1.1
brew install postman
brew install pre-commit
brew install shottr
brew install slack
brew install soapui
brew install sops
brew install stern
brew install sublime-text
brew install telepresence
brew install tmux
brew install tree
brew install visual-studio-code
brew install vlc
brew install yq


# Remove outdated versions from the cellar.
brew cleanup
