import os
import random
from PIL import Image

# Configuration
source_folder = "/path/to/source/folder"  # Change this to your source folder
destination_folder = "/path/to/destination/folder"  # Change this to your destination folder
output_filename = "wallpaper.jpg"
screen_width = 2560
screen_height = 1080

def resize_image(image_path, output_path):
    img = Image.open(image_path)
    
    # Preserve aspect ratio while fitting within 2560x1080
    img.thumbnail((screen_width, screen_height), Image.LANCZOS)

    # Save as JPG with quality 90
    img.convert("RGB").save(output_path, "JPEG", quality=90)

def main():
    # Get all image files from source folder
    images = [f for f in os.listdir(source_folder) if f.lower().endswith(('png', 'jpg', 'jpeg', 'bmp', 'gif', 'webp'))]
    
    if not images:
        print("No images found in the source folder.")
        return

    # Pick a random image
    random_image = random.choice(images)
    image_path = os.path.join(source_folder, random_image)
    output_path = os.path.join(destination_folder, output_filename)

    print(f"Processing: {random_image}")
    
    resize_image(image_path, output_path)
    print(f"Wallpaper saved to {output_path}")

if __name__ == "__main__":
    main()
