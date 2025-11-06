# Import library Pillow untuk memproses gambar
from PIL import Image, ImageDraw, ImageFont
import argparse
import os
import sys
import json

# Setup argument parser
parser = argparse.ArgumentParser(description='Generate certificates with names')
parser.add_argument('--names', nargs='+', required=True, help='List of names for certificates')
parser.add_argument('--image', required=True, help='Path to base certificate image')
parser.add_argument('--output', required=True, help='Output directory for certificates')
parser.add_argument('--position', nargs=2, type=float, required=True, help='X Y position for text')

args = parser.parse_args()

# Get names from command line
nama = args.names

# Create output directory if it doesn't exist
os.makedirs(args.output, exist_ok=True)

def res_path(relative_path):
    try:
        # PyInstaller creates a temp folder and stores path in _MEIPASS
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")

    return os.path.join(base_path, relative_path)

# List to store output paths
output_paths = []

# Loop untuk memproses setiap nama di file
for name in nama:
    # Membuka file gambar template sertifikat
    img = Image.open(args.image)

    # Membuat objek untuk menggambar di atas gambar
    draw = ImageDraw.Draw(img)

    # Menentukan jenis font dan ukuran tulisan
    # Try to use bundled font first, fallback to system fonts
    font = None
    try:
        font_path = res_path("Montserrat-Bold.ttf")
        font = ImageFont.truetype(font_path, 36)
    except Exception as e:
        # Fallback to default system fonts
        try:
            # Try common macOS fonts (System UI font)
            font = ImageFont.truetype("/System/Library/Fonts/SFNS.ttf", 36)
        except:
            try:
                font = ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 36)
            except:
                try:
                    # Try Arial as last resort
                    font = ImageFont.truetype("/System/Library/Fonts/Supplemental/Arial.ttf", 36)
                except:
                    # This should not happen, but if it does, raise an error
                    raise Exception("No suitable font found. Please ensure font files are available.")

    # Mengukur ukuran teks agar bisa diposisikan di tengah
    bbox = draw.textbbox((0, 0), name, font=font)
    text_width = bbox[2] - bbox[0]   # Lebar teks
    text_height = bbox[3] - bbox[1]  # Tinggi teks

    # Center the text horizontally on the crosshair position
    # Use anchor='mm' (middle-middle) to center the text at the exact position
    text_x = args.position[0]
    text_y = args.position[1]

    # Menulis teks (nama) ke gambar
    # (0, 0, 128) adalah warna teks (navy)
    # anchor='mm' means the position is the middle-middle of the text
    draw.text((text_x, text_y), name, (0, 0, 128), font=font, anchor='mm')

    # Menyimpan hasil gambar ke folder output dengan nama sesuai nama peserta
    output_path = os.path.join(args.output, name + ".jpg")
    img.save(output_path)
    output_paths.append(output_path)

# Output JSON for Flutter app
print(json.dumps({"output_paths": output_paths}))

#Use this command to make executable with font included:
"""pyinstaller --onefile --add-data "Montserrat-Bold.ttf:." sertific8.py"""