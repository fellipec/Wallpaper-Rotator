import os
import requests
import tempfile
from PIL import Image
import subprocess
import configparser

# Config file location
CONFIG_PATH = os.path.expanduser("~/.config/wallpaper-rotator/config.ini")

# Load config
config = configparser.ConfigParser()
config.read(CONFIG_PATH)

WALLPAPER_URL = config["general"]["wallpaper_url"]
SAVE_PATH = os.path.expanduser(config["general"]["save_path"])
TEMP_PATH = "/tmp/temp_wallpaper.jpg"

def download_wallpaper(url):
    """Downloads the wallpaper to a temporary file."""
    try:
        response = requests.get(url, stream=True, timeout=10)
        response.raise_for_status()
        
        temp_file = tempfile.NamedTemporaryFile(delete=False, suffix=".jpg")
        with open(temp_file.name, "wb") as f:
            for chunk in response.iter_content(1024):
                f.write(chunk)
        
        return temp_file.name
    except Exception as e:
        print(f"Error downloading wallpaper: {e}")
        return None

def validate_image(file_path):
    """Checks if the downloaded file is a valid image."""
    try:
        with Image.open(file_path) as img:
            img.verify()  # Check for corruption
        return True
    except Exception:
        print("Downloaded file is not a valid image.")
        return False

def set_wallpaper(image_path):
    """Sets the wallpaper using gsettings (Cinnamon DE)."""
    subprocess.run([
        "gsettings", "set", "org.cinnamon.desktop.background",
        "picture-uri", f"file://{image_path}"
    ], check=True)

def main():
    print("Fetching wallpaper...")
    temp_wallpaper = download_wallpaper(WALLPAPER_URL)

    if temp_wallpaper and validate_image(temp_wallpaper):
        # Move to final location
        with open(temp_wallpaper, "rb") as src, open(SAVE_PATH, "wb") as dst:
            dst.write(src.read())
        os.remove(temp_wallpaper)  # Clean up the temp file
        print("Wallpaper updated successfully!")
        set_wallpaper(SAVE_PATH)
    else:
        print("Wallpaper update failed.")

if __name__ == "__main__":
    main()
