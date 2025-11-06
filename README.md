# Sertific8

Ini adalah project yang diperuntukkan untuk memenuhi tugas proyek akhir dari matakuliah Algoritma dan Pemrograman Semester 3.

Aplikasi ini akan mengambil sebuah file gambar sertifikat, yang nantinya akan ditandai oleh user tempat untuk mengisi nama-nama pada sertifikat tersebut.

Aplikasi ini direncanakan akan rilis untuk Desktop (Windows, MacOS, dan Linux)

---

## 📋 Alur Aplikasi

### 1. **Pilih Template Sertifikat**
- Pengguna membuka aplikasi dan klik tombol untuk memilih file gambar template sertifikat
- Format yang didukung: JPG, PNG
- Template akan digunakan sebagai dasar untuk semua sertifikat

### 2. **Tentukan Posisi Teks**
- Template ditampilkan di layar
- Pengguna dapat menghover mouse untuk melihat posisi pixel
- Klik pada posisi di mana nama harus ditempatkan
- Crosshair merah akan muncul untuk menandai posisi yang terkunci
- Klik lagi untuk mengubah posisi jika perlu

### 3. **Input Nama-Nama**
Pengguna memiliki dua opsi untuk memasukkan nama:

#### **Opsi A: Input Manual**
- Klik tab "Manual"
- Masukkan nama satu per satu
- Klik tombol "+" untuk menambah nama baru
- Setiap nama dapat dihapus jika terjadi kesalahan
- Nama dengan spasi didukung (contoh: "John Doe")

#### **Opsi B: Import dari CSV**
- Klik tab "CSV"
- Pilih file CSV yang berisi daftar nama
- Aplikasi akan menampilkan preview data dalam bentuk tabel
- Pilih kolom yang berisi nama-nama
- Nama dari kolom tersebut akan digunakan

### 4. **Konfirmasi Data**
Layar konfirmasi menampilkan:
- **Preview template sertifikat** (gambar kecil)
- **Daftar semua nama** yang akan diproses (scrollable)
- **Posisi pixel** yang dipilih (X, Y)
- **Folder output** - lokasi penyimpanan hasil

Pengguna dapat:
- Memilih folder output untuk menyimpan hasil
- Mengubah folder jika perlu
- Memeriksa semua data sebelum memproses

### 5. **Proses Pembuatan Sertifikat**
- Klik tombol "Proses & Buat Sertifikat"
- Loading indicator muncul
- Python script dijalankan di background
- Script menghasilkan satu file JPG untuk setiap nama
- Progress ditampilkan

### 6. **Hasil & Manajemen File**
Setelah proses selesai, layar hasil menampilkan:

#### **Grid Sertifikat**
- Semua sertifikat ditampilkan dalam grid responsif
- Setiap card menampilkan preview dan nama file
- **Semua sertifikat dipilih secara default**

#### **Aksi yang Tersedia**
- **Select All / Deselect All**: Memilih atau membatalkan semua pilihan
- **Print**: Membuka dialog share macOS untuk:
  - Print ke printer fisik
  - Save as PDF
  - Share via aplikasi lain
- **Hapus**: Menghapus sertifikat yang dipilih (dengan konfirmasi)
- **Selesai & Kembali ke Menu**: Reset aplikasi dan kembali ke menu utama

---

## 🚀 Cara Menjalankan Aplikasi

### **Prasyarat**
- Flutter SDK (versi 3.9.2 atau lebih tinggi)
- Dart SDK
- Xcode (untuk macOS)
- Visual Studio (untuk Windows)

### **1. Clone Repository**
```bash
git clone https://github.com/rmaprojects/Sertific8.git
cd Sertific8
```

### **2. Install Dependencies**
```bash
flutter pub get
```

### **3. Jalankan Aplikasi**

#### **Untuk macOS:**
```bash
flutter run -d macos
```

#### **Untuk Windows:**
```bash
flutter run -d windows
```

#### **Untuk Linux:**
```bash
flutter run -d linux
```

### **4. Build Aplikasi (Release)**

#### **Build untuk macOS:**
```bash
flutter build macos --release
```
Hasil build ada di: `build/macos/Build/Products/Release/sertific8.app`

#### **Build untuk Windows:**
```bash
flutter build windows --release
```
Hasil build ada di: `build/windows/x64/runner/Release/`

#### **Build untuk Linux:**
```bash
flutter build linux --release
```
Hasil build ada di: `build/linux/x64/release/bundle/`

---

## 🐧 Membuat Executable Python untuk Linux

Jika Anda menggunakan Linux dan ingin membuat executable Python sendiri (karena owner tidak memiliki OS Linux):

### **1. Install Python dan Dependencies**
```bash
# Install Python 3 (jika belum ada)
sudo apt update
sudo apt install python3 python3-pip python3-venv

# Atau untuk Fedora/RHEL:
sudo dnf install python3 python3-pip
```

### **2. Setup Virtual Environment**
```bash
cd /path/ke/project/Sertific8/pythonscript

# Buat virtual environment
python3 -m venv venv

# Aktifkan virtual environment
source venv/bin/activate
```

### **3. Install Requirements**
```bash
pip install pillow pyinstaller
```

### **4. Download Font**
Pastikan file `Montserrat-Bold.ttf` ada di folder `pythonscript/`. Jika tidak ada, download dari:
```bash
wget https://github.com/google/fonts/raw/main/ofl/montserrat/Montserrat-Bold.ttf
```

### **5. Build Executable dengan PyInstaller**
```bash
# Pastikan masih di dalam virtual environment
pyinstaller --onefile --add-data="Montserrat-Bold.ttf:." sertific8.py --clean
```

Parameter penjelasan:
- `--onefile`: Membuat satu file executable
- `--add-data="Montserrat-Bold.ttf:."`: Menyertakan font dalam executable
- `--clean`: Membersihkan cache sebelum build

### **6. Copy Executable ke Folder Flutter**
```bash
# Executable hasil build ada di folder dist/
cp dist/sertific8 ../executables/linux/sertific8
chmod +x ../executables/linux/sertific8
```

### **7. Test Executable**
```bash
cd ../executables/linux
./sertific8 --names "Test User" --image /path/to/template.jpg --output /path/to/output --position 435 243
```

Output yang benar:
```json
{"output_paths": ["/path/to/output/Test User.jpg"]}
```

### **8. Rebuild Flutter App**
Setelah executable Linux siap, rebuild aplikasi Flutter:
```bash
cd ../..  # Kembali ke root project
flutter build linux --release
```

### **Troubleshooting Linux**

#### **Error: Font tidak ditemukan**
```bash
# Install font system untuk fallback
sudo apt install fonts-dejavu-core
```

#### **Error: Library tidak ditemukan**
```bash
# Install dependencies yang mungkin diperlukan
sudo apt install libgtk-3-dev libglib2.0-dev
```

#### **Executable terlalu besar**
```bash
# Gunakan UPX untuk kompresi (opsional)
sudo apt install upx
upx --best dist/sertific8
```

---

## 📦 Struktur Project

```
Sertific8/
├── lib/
│   ├── main.dart                 # Entry point aplikasi
│   ├── components/               # Komponen UI reusable
│   ├── routes/                   # Konfigurasi routing
│   ├── services/                 # Service layer (Python script)
│   ├── states/                   # State management (Provider)
│   └── views/                    # Screens/Pages
│       ├── main/                 # Menu utama
│       ├── pixel_selector/       # Pilih posisi pixel
│       ├── name_input_sheet/     # Input nama (manual/CSV)
│       ├── confirmation/         # Konfirmasi data
│       └── results/              # Hasil sertifikat
├── pythonscript/
│   ├── sertific8.py              # Script Python utama
│   └── Montserrat-Bold.ttf       # Font yang digunakan
├── executables/
│   ├── macos/sertific8           # Executable untuk macOS
│   ├── windows/sertific8.exe     # Executable untuk Windows
│   └── linux/sertific8           # Executable untuk Linux (Masih dalam proses)
├── macos/                        # Konfigurasi macOS
├── windows/                      # Konfigurasi Windows
├── linux/                        # Konfigurasi Linux
└── pubspec.yaml                  # Dependencies Flutter
```

---

## 🔧 Dependencies

### **Flutter Packages:**
- `go_router`: Navigation dan routing
- `provider`: State management
- `file_selector`: Memilih file dan folder
- `csv`: Parsing file CSV
- `process_run`: Menjalankan executable Python
- `path_provider`: Akses direktori temporary
- `printing`: Fungsi print dan PDF
- `pdf`: Generate PDF dari gambar
- `window_manager`: Manajemen window desktop

### **Python Packages:**
- `Pillow (PIL)`: Image processing
- `PyInstaller`: Membuat executable

---

## 📝 Catatan Penting

1. **Koordinat Pixel**: Aplikasi secara otomatis menghitung scaling antara gambar yang ditampilkan dan file asli
2. **Font**: Executable Python sudah menyertakan font Montserrat-Bold.ttf
3. **Nama dengan Spasi**: Didukung penuh (contoh: "John Doe", "Maria Christina")
4. **Output Format**: Semua hasil dalam format JPG
5. **Text Centering**: Text diposisikan dengan anchor center, posisi crosshair adalah center dari text

## 👥 Contributors

- **Owner**: Kelompok 8 Algoritma dan Pemrograman
- **Beranggotakan**:
   - Raka Muhammad Al Hafidz (241344087)
   - Rifky Maulana Syahdan (241344088)
   - Raisya Kamilatulhuda (241344086)
- **Repository**: [github.com/rmaprojects/Sertific8](https://github.com/rmaprojects/Sertific8)

---

## 📄 License

Project ini dibuat untuk keperluan tugas akademik.

