# MRZ's Neovim Configuration
Welcome to MRZ's personal Neovim setup! This is a lightweight but powerful configuration designed for modern development, primarily focused on Kotlin, Java, and shell scripting. It balances aesthetics with functionality, providing a full IDE-like experience directly in your terminal.

## Features
This configuration is built from scratch and includes the following features:

### Core Tools
* **Plugin Manager:** Uses `lazy.nvim` for fast, declarative plugin management.
* **File Explorer:** `nvim-tree` for a familiar file tree interface.
* **Fuzzy Finder:** `telescope.nvim` to instantly find files, text, and more.
* **Optimized Highlighting:** `nvim-treesitter` for fast and accurate syntax highlighting.

### IDE Features
* **LSP Integration:** Full Language Server Protocol support via `nvim-lspconfig`.
* **Automatic Installation:** `mason.nvim` automatically installs and manages language servers.
* **Autocompletion:** A powerful completion engine powered by `nvim-cmp`.
* **Code Snippets:** `LuaSnip` and `friendly-snippets` for boilerplate reduction and efficiency.

### Quality of Life
* **Git Integration:** `gitsigns` to show changes in the sign column and `lazygit` for a full Git UI.
* **Easy Commenting:** `Comment.nvim` for toggling comments with simple key presses.
* **Auto-Closing Pairs:** `nvim-autopairs` automatically closes brackets, quotes, and parentheses.

### Personalization (MRZ Edition)
* **Custom Dashboard:** A personalized welcome screen powered by `alpha-nvim`.
* **Custom Statusline:** A sleek status line via `lualine.nvim` featuring the MRZ name.
* **Colorscheme:** The popular `tokyonight` theme.

## Installation
Ensure you have the necessary dependencies installed: `git` and the latest `nvim`.
Copy and run the one-line command below in your terminal.

```bash
/bin/bash -c "$(curl -fsSL [https://raw.githubusercontent.com/mena-rizkalla/mrz-nvim/main/install.sh](https://raw.githubusercontent.com/mena-rizkalla/mrz-nvim/main/install.sh))"
```
The script (detailed below) will automatically back up your existing Neovim configuration to `~/.config/nvim.bak` before installing.
<details>
<summary>Click to view the installation script</summary>

```bash
#!/usr/bin/env bash

# MRZ's Neovim Configuration Installer
#
# This script installs MRZ's personal Neovim setup.
# It will back up your existing Neovim config to ~/.config/nvim.bak

# --- Variables ---
NVIM_CONFIG_DIR="$HOME/.config/nvim"
NVIM_CONFIG_BACKUP_DIR="$HOME/.config/nvim.bak"
REPO_URL="[https://github.com/mena-rizkalla/mrz-nvim.git](https://github.com/mena-rizkalla/mrz-nvim.git)"

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
```
</details>

## Keymaps
Your **Leader** key is `<Space>`.

| Keys | Action | Plugin |
|---|---|---|
| `<Space> e` | Open/Close the File Explorer | `nvim-tree` |
| `<Space> gg` | Open Lazygit | `lazygit.nvim` |
| `<Space> w` | Save the current file | (Vim command) |
| `<Space> ff` | Find Files | `telescope.nvim` |
| `<Space> fg` | Find text with Grep | `telescope.nvim` |
| `gd` | Go to Definition | LSP |
| `K` | Show documentation on Hover | LSP |
| `<Space> ca` | Show Code Actions (refactor, etc.) | LSP |
| `<Space> f` | Format the current file | LSP |
| `gcc` | Comment/Uncomment the current line | `Comment.nvim` |
| `<Tab>` / `<S-Tab>` | Jump between snippet placeholders | `LuaSnip` |
