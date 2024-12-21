#!/bin/bash

# Ensure yay is installed
if ! command -v yay &>/dev/null; then
    echo "yay not found. Please install yay first."
    exit 1
fi

# Update system and install required packages
echo "Installing Zsh, Nano, and fonts..."
yay -S zsh nano nerd-fonts-complete --noconfirm --needed

# Clone and set up Zsh plugins
echo "Setting up Zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Zsh Autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Cloning Zsh Autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Install Zsh Syntax Highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Cloning Zsh Syntax Highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# Install Powerlevel10k
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    echo "Cloning Powerlevel10k..."
    git clone https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Configure Zsh
echo "Configuring Zsh..."
sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|' "$HOME/.zshrc"
sed -i '/^plugins=(/ s/)/ zsh-autosuggestions zsh-syntax-highlighting)/' "$HOME/.zshrc"

# Install Nano syntax highlighting
echo "Setting up Nano syntax highlighting..."
NANO_SYNTAX_DIR="$HOME/.nano/syntax"
if [ ! -d "$NANO_SYNTAX_DIR" ]; then
    git clone https://github.com/scopatz/nanorc.git "$NANO_SYNTAX_DIR"
    echo "include $NANO_SYNTAX_DIR/*.nanorc" >>"$HOME/.nanorc"
fi

# Set Zsh as the default shell
echo "Setting Zsh as the default shell..."
chsh -s "$(command -v zsh)"
p10k configure
echo "Installation complete! Restart your terminal or log in again to start using Zsh."
