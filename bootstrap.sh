
sh brew.sh

source .macos

if [ -d "/Applications/iTerm.app" ]; then
  echo "Setting up iTerm2 preferences..."

  # Specify the preferences directory
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "$(pwd)/iterm"

  # Tell iTerm2 to use the custom preferences in the directory
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

  #  Enable Shell Integration
  curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
fi

# tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Linking tmux config
ln -fv $(PWD)/.tmux.conf $HOME/.tmux.conf

# Linking nvim config
ln -sfv $(PWD)/nvim  ${HOME}/.config/