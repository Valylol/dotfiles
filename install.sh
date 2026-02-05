#!/bin/bash
# install.sh - Automated dotfiles and package restoration for fresh Arch install

set -e  # Exit on error

DOTFILES_REPO="https://github.com/Valylol/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Starting dotfiles installation...${NC}"

# Check if running on Arch
if ! command -v pacman &> /dev/null; then
    echo -e "${RED}Error: This script is for Arch Linux only${NC}"
    exit 1
fi

# Install git if not present
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}==> Installing git...${NC}"
    sudo pacman -S --noconfirm git
fi

# Clone dotfiles if not already cloned
if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${YELLOW}==> Cloning dotfiles repository...${NC}"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
else
    echo -e "${YELLOW}==> Dotfiles already cloned, updating...${NC}"
    cd "$DOTFILES_DIR"
    git pull
fi

# Install stow
if ! command -v stow &> /dev/null; then
    echo -e "${YELLOW}==> Installing stow...${NC}"
    sudo pacman -S --noconfirm stow
fi

# Install base-devel (needed for yay)
echo -e "${YELLOW}==> Installing base-devel...${NC}"
sudo pacman -S --needed --noconfirm base-devel

# Install yay if not present
if ! command -v yay &> /dev/null; then
    echo -e "${YELLOW}==> Installing yay...${NC}"
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
fi

# Install pacman packages
if [ -f "$DOTFILES_DIR/pkglist.txt" ]; then
    echo -e "${YELLOW}==> Installing pacman packages...${NC}"
    sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/pkglist.txt" || true
else
    echo -e "${RED}Warning: pkglist.txt not found, skipping pacman packages${NC}"
fi

# Install AUR packages
if [ -f "$DOTFILES_DIR/aurlist.txt" ]; then
    echo -e "${YELLOW}==> Installing AUR packages...${NC}"
    yay -S --needed --noconfirm - < "$DOTFILES_DIR/aurlist.txt" || true
else
    echo -e "${RED}Warning: aurlist.txt not found, skipping AUR packages${NC}"
fi

# Backup existing configs
echo -e "${YELLOW}==> Backing up existing configs...${NC}"
mkdir -p ~/.config-backup
for dir in ~/.config/*; do
    dirname=$(basename "$dir")
    if [ -d "$DOTFILES_DIR/config/$dirname" ]; then
        mv "$dir" ~/.config-backup/ 2>/dev/null || true
    fi
done

# Stow dotfiles
echo -e "${YELLOW}==> Restoring dotfiles with stow...${NC}"
cd "$DOTFILES_DIR"

# Stow config files
if [ -d "config" ]; then
    stow -t ~/.config config
fi

# Stow shell configs
if [ -d "shell" ]; then
    stow -t ~ shell
fi

# Stow any other directories that exist
for dir in */; do
    dirname=$(basename "$dir")
    if [ "$dirname" != "config" ] && [ "$dirname" != "shell" ] && [ "$dirname" != ".git" ]; then
        stow -t ~ "$dirname" || true
    fi
done

echo -e "${GREEN}==> Installation complete!${NC}"
echo -e "${YELLOW}Your old configs are backed up in ~/.config-backup${NC}"
echo -e "${YELLOW}You may need to reboot for some changes to take effect.${NC}"
