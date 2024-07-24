#!/usr/bin/env bash


###############################################################################
# Homebrew and applications setup
###############################################################################
# Ensure Homebrew is installed
if ! command -v brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew
brew update

# List of applications to install via Homebrew Cask
apps=(
  anaconda
  chatgpt
  docker
  dropbox
  foxitreader
  google-chrome
  google-drive
  microsoft-excel
  microsoft-onenote
  microsoft-outlook
  microsoft-powerpoint
  microsoft-teams
  microsoft-word
  onedrive
  pgadmin4
  skype
  visual-studio-code
  zoom
)

# Install applications
for app in "${apps[@]}"; do
  brew install --cask "$app"
done


###############################################################################
# Set up Dock items
###############################################################################
# Install dockutil if not already installed
if ! command -v dockutil &> /dev/null; then
  brew install dockutil
fi

# Clear existing Dock items
dockutil --remove all --no-restart

# Add default items to the Dock
dockutil --add /System/Applications/System\ Settings.app --no-restart
dockutil --add /System/Applications/Utilities/Terminal.app --no-restart

# Add separator (vertical bar) 
dockutil --add '' --type spacer --section apps --no-restart

# Add specified applications to the Dock
dockutil --add /Applications/Google\ Chrome.app --no-restart
dockutil --add /Applications/Microsoft\ Outlook.app --no-restart
dockutil --add /Applications/Microsoft\ Teams.app --no-restart
dockutil --add /Applications/Visual\ Studio\ Code.app --no-restart
dockutil --add /Applications/ChatGPT.app --no-restart
dockutil --add /Applications/Notes.app --no-restart

# Restart the Dock to apply changes
killall Dock


###############################################################################
# Anaconda Setup
###############################################################################
# Function to set up Anaconda and initialize Conda
setup_anaconda_conda() {
  local anaconda_path="/opt/homebrew/anaconda3/bin"
  
  # Check if Anaconda is installed
  if [ -d "$anaconda_path" ]; then
    # Add Anaconda to PATH if not already present
    if ! grep -q "$anaconda_path" ~/.zshrc; then
      echo "Adding Anaconda to PATH in .zshrc"
      echo "export PATH=\"$anaconda_path:\$PATH\"" >> ~/.zshrc
      echo "Anaconda added to PATH."
    fi

    if ! grep -q "$anaconda_path" ~/.bash_profile; then
      echo "Adding Anaconda to PATH in .bash_profile"
      echo "export PATH=\"$anaconda_path:\$PATH\"" >> ~/.bash_profile
      echo "Anaconda added to PATH."
    fi

    # Initialize Conda
    if command -v conda &> /dev/null; then
      echo "Initializing Conda for Zsh and Bash..."
      conda init zsh
      conda init bash
      # If conda init does not work, try adding the initialization manually for Zsh and Bash
      # Add Conda initialization to .zshrc if not present
      if ! grep -q "conda.sh" ~/.zshrc; then
        echo "source /opt/homebrew/anaconda3/etc/profile.d/conda.sh" >> ~/.zshrc
      fi

      # Add Conda initialization to .bash_profile if not present
      if ! grep -q "conda.sh" ~/.bash_profile; then
        echo "source /opt/homebrew/anaconda3/etc/profile.d/conda.sh" >> ~/.bash_profile
      fi

      # Source the shell configuration files
      echo "Sourcing $HOME/.zshrc and $HOME/.bash_profile..."
      source "$HOME/.zshrc"
      source "$HOME/.bash_profile"
    else
      echo "Conda is not installed. Please install Anaconda properly."
    fi
  else
    echo "Anaconda installation directory not found: $anaconda_path"
  fi
}

# Call the function to set up Anaconda and initialize Conda
setup_anaconda_conda


###############################################################################
# VS Code Setup
###############################################################################
# List of VS Code extensions to install
vscode_extensions=(
  ms-python.python
  ms-python.flake8
  ms-toolsai.jupyter
  ms-vscode-remote.remote-ssh
  github.copilot
  # Add more extensions here
)

# Function to install VS Code extensions
install_vscode_extensions() {
  # Check if VS Code is installed
  if ! command -v code &> /dev/null; then
    echo "VS Code is not installed. Please install VS Code to proceed."
    exit 1
  fi

  # Install each VS Code extension
  for extension in "${vscode_extensions[@]}"; do
    code --install-extension "$extension"
  done

}

# Call the function to install VS Code extensions
install_vscode_extensions

# Function to configure VS Code settings
configure_vscode_settings() {
  local settings_path="$HOME/Library/Application Support/Code/User/settings.json"
  
  # Create settings.json file if it does not exist
  if [ ! -f "$settings_path" ]; then
    echo "{}" > "$settings_path"
  fi

  # Add rulers to settings.json
  echo "Updating VS Code settings to include rulers..."
  jq '.["editor.rulers"] = [79, 100]' "$settings_path" > tmp.json && mv tmp.json "$settings_path"

  echo "VS Code settings updated with rulers at 79 and 100 columns."
}

# Call the function to configure VS Code settings
configure_vscode_settings


###############################################################################
# Complete
###############################################################################
echo "Setup complete!"
