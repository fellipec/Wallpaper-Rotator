#!/bin/bash

# Configuration
REPO_URL="https://github.com/fellipec/wallpaper-rotator.git"
INSTALL_DIR="$HOME/.local/wallpaper-rotator"
VENV_DIR="$INSTALL_DIR/venv"
PYTHON_BIN="python3"
CONFIG_DIR="$HOME/.config/wallpaper-rotator"
CONFIG_FILE="$CONFIG_DIR/config.ini"
DEFAULT_CONFIG="config.ini.example"  # The example config provided with the repo

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

echo "Setting up wallpaper-rotator..."

# Ensure the config directory exists
mkdir -p "$CONFIG_DIR"

# Copy config if it doesn't exist
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Copying default config..."
    cp "$DEFAULT_CONFIG" "$CONFIG_FILE"
else
    echo "Config already exists. Skipping copy."
fi

# Run the wallpaper client
echo "Running wallpaper client..."
python "$INSTALL_DIR/getwallpaper.py"

# Deactivate virtual environment
deactivate

# Add cron job for automatic updates
CRON_CMD="2 */4 * * * $HOME/.local/wallpaper-rotator/venv/bin/python3 $HOME/.local/wallpaper-rotator/getwallpaper.py"
CRON_JOB="$(crontab -l 2>/dev/null | grep -F "$CRON_CMD")"

if [ -z "$CRON_JOB" ]; then
    echo "Setting up cron job to update wallpaper every hour..."
    (crontab -l 2>/dev/null; echo "$CRON_CMD") | crontab -
else
    echo "Cron job already exists."
fi

echo "Installation complete!"