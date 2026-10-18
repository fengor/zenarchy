#!/bin/bash
set -e

# Check if paru is installed
if ! command -v paru &> /dev/null; then
    echo "paru is not installed. Installing prerequisites and paru..."
    
    # Ensure build essentials and rust compiler are present
    sudo pacman -S --needed --noconfirm base-devel git rust
    
    # Clone and build paru from the AUR
    TMP_DIR=$(mktemp -d)
    git clone https://aur.archlinux.org/paru.git "$TMP_DIR/paru"
    
    cd "$TMP_DIR/paru"
    makepkg -si --noconfirm
    
    # Cleanup temporary build files
    cd - > /dev/null
    rm -rf "$TMP_DIR"
    
    echo "paru installed successfully."
else
    echo "paru is already installed."
fi

REPO_NAME="zenarchy"
REPO_URL="https://fengor.github.io/zenarchy/\$arch/"

# Check if the repository is already present in pacman.conf
if grep -q "\[$REPO_NAME\]" /etc/pacman.conf; then
    echo "Repository [$REPO_NAME] is already configured."
else
    echo "Adding [$REPO_NAME] to /etc/pacman.conf..."

    # Append repository configuration to pacman.conf
    sudo tee -a /etc/pacman.conf > /dev/null <<EOF

[$REPO_NAME]
Server = $REPO_URL
EOF

    echo "Synchronizing package databases..."
    sudo pacman -Sy
    echo "Repository added successfully."
fi
