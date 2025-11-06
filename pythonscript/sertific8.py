# Import library Pillow untuk memproses gambar
from PIL import Image, ImageDraw, ImageFont
import argparse
import os
import sys

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

# Loop untuk memproses setiap nama di file
for name in nama:
    # Membuka file gambar template sertifikat
    img = Image.open(args.image)

    # Membuat objek untuk menggambar di atas gambar
    draw = ImageDraw.Draw(img)

    # Menentukan jenis font dan ukuran tulisan
    # Pastikan file font "Montserrat-Bold.ttf" ada di folder yang sama
    font_path = res_path("Montserrat-Bold.ttf")
    font = ImageFont.truetype(font_path, 36)

    # Mengukur ukuran teks agar bisa diposisikan di tengah
    bbox = draw.textbbox((0, 0), name, font=font)
    text_width = bbox[2] - bbox[0]   # Lebar teks
    text_height = bbox[3] - bbox[1]  # Tinggi teks

    # Use provided position
    text_x = args.position[0]
    text_y = args.position[1]

    # Menulis teks (nama) ke gambar
    # (0, 0, 128) adalah warna teks (navy)
    draw.text((text_x, text_y), name, (0, 0, 128), font=font)

    # Menyimpan hasil gambar ke folder output dengan nama sesuai nama peserta
    output_path = os.path.join(args.output, name + ".jpg")
    img.save(output_path)

    # Memberi informasi di terminal bahwa sertifikat sudah dibuat
    print("Berhasil untuk " + name)