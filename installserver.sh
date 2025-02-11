#!/bin/bash

# Configuration
REPO_URL="https://github.com/fellipec/wallpaper-rotator.git"
INSTALL_DIR="$HOME/wallpaper-rotator"
VENV_DIR="$INSTALL_DIR/venv"
PYTHON_BIN="python3"

# Ensure git is installed
if ! command -v git &>/dev/null; then
    echo "Error: git is not installed. Install it and retry."
    exit 1
fi

# Clone or update the repository
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "Updating existing repository..."
    git -C "$INSTALL_DIR" pull
else
    echo "Cloning repository..."
    git clone --depth 1 "$REPO_URL" "$INSTALL_DIR"
fi

# Create and activate virtual environment
echo "Setting up virtual environment..."
$PYTHON_BIN -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

# Install dependencies
if [ -f "$INSTALL_DIR/requirements.txt" ]; then
    echo "Installing dependencies..."
    pip install --upgrade pip
    pip install -r "$INSTALL_DIR/requirements.txt"
else
    echo "No requirements.txt found, skipping dependency installation."
fi


