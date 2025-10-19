#!/usr/bin/env bash

# MRZ's Neovim Configuration Installer
#
# This script installs MRZ's personal Neovim setup.
# It will back up your existing Neovim config to ~/.config/nvim.bak

# --- Variables ---
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_CONFIG_BACKUP_DIR="$HOME/.config/nvim.bak"
REPO_URL="https://github.com/mena-rizkalla/mrz-nvim.git"

# --- Functions ---

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# --- Main Script ---

echo "Starting installation of MRZ's Neovim configuration..."

# 1. Check for dependencies
if ! command_exists git; then
  echo "Error: git is not installed. Please install git and try again."
  exit 1
fi

if ! command_exists nvim; then
  echo "Error: Neovim is not installed. Please install the latest version of Neovim and try again."
  exit 1
fi

echo "Dependencies found."

# 2. Back up existing configuration (if it exists)
if [ -d "$NVIM_CONFIG_DIR" ]; then
  echo "Existing Neovim configuration found. Backing it up to $NVIM_CONFIG_BACKUP_DIR..."
  if [ -d "$NVIM_CONFIG_BACKUP_DIR" ]; then
    echo "Backup directory $NVIM_CONFIG_BACKUP_DIR already exists. Removing it."
    rm -rf "$NVIM_CONFIG_BACKUP_DIR"
  fi
  mv "$NVIM_CONFIG_DIR" "$NVIM_CONFIG_BACKUP_DIR"
  echo "Backup complete."
fi

# 3. Clone the new configuration
echo "Cloning the mrz-nvim repository from GitHub..."
if ! git clone "$REPO_URL" "$NVIM_CONFIG_DIR"; then
  echo "Error: Failed to clone the repository. Please check the URL and your internet connection."
  exit 1
fi

# 4. Final message
echo ""
echo "✅ MRZ's Neovim configuration has been installed successfully!"
echo "Please start Neovim. Plugins will be installed automatically on the first run."
echo "Enjoy your new setup!"
