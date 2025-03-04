# MDS_K2_Database-Jurusan
![Image](https://github.com/user-attachments/assets/4586966d-c39b-49b7-b5f1-faca06320033)

## 1. Pendahuluan
Dalam era digital, pengelolaan data perguruan tinggi yang efisien sangat penting untuk mendukung pengambilan keputusan yang berbasis data. Data terkait wilayah, universitas, program studi (prodi), dan jalur masuk perlu disimpan dalam suatu sistem database yang terstruktur, mudah diakses, dan dapat divisualisasikan secara interaktif.

Teknologi yang digunakan :
Database:
MySQL (via dbngin) → Digunakan untuk menyimpan data secara terstruktur.
R (RMySQL dan DBI package) → Untuk koneksi ke database, pembuatan tabel, dan impor data.

Pengolahan Data:
R (tidyverse, dplyr, readr, DBI) → Digunakan untuk pembersihan, manipulasi, dan transformasi data sebelum dimasukkan ke dalam database.

Visualisasi & Dashboard:
R Shiny → Untuk membangun antarmuka pengguna interaktif yang memungkinkan eksplorasi data perguruan tinggi dalam bentuk grafik, tabel, dan filter dinamis.

## 2. Struktur Database
Database ini dinamakan **K2JURUSAN** dan terdiri dari empat tabel utama:

### **Tabel Wilayah**
Menyimpan informasi tentang wilayah administratif perguruan tinggi.
- `id_wilayah` (INT, Primary Key)
- `Nama_Kabkota` (VARCHAR) – Nama kota/kabupaten
- `nama_prov` (VARCHAR) – Nama provinsi

### **Tabel Universitas**
Menyimpan informasi tentang universitas.
- `id_univ` (INT, Primary Key, AUTO_INCREMENT)
- `id_wilayah` (INT, Foreign Key ke Wilayah)
- `nama_univ` (VARCHAR) – Nama universitas
- `akred_univ` (CHAR) – Akreditasi universitas

### **Tabel Prodi (Program Studi)**
Menyimpan informasi tentang program studi di setiap universitas.
- `id_prodi` (INT, Primary Key, AUTO_INCREMENT)
- `id_univ` (INT, Foreign Key ke Universitas)
- `nama_prodi` (VARCHAR) – Nama program studi
- `jumlah_dosen` (INT) – Jumlah dosen di prodi
- `jumlah_mahasiswa` (INT) – Jumlah mahasiswa di prodi
- `akred_prodi` (CHAR) – Akreditasi program studi
- `jenjang` (VARCHAR) – Jenjang pendidikan (S1, S2, S3)

### **Tabel Jalur Masuk**
Menyimpan informasi tentang jalur masuk ke universitas dan program studi.
- `id_jalur` (INT, Primary Key, AUTO_INCREMENT)
- `id_prodi` (INT, Foreign Key ke Prodi)
- `id_univ` (INT, Foreign Key ke Universitas)
- `jalur_masuk` (VARCHAR) – Nama jalur masuk
- `daya_tampung` (INT) – Kapasitas daya tampung
- `website` (VARCHAR) – Website informasi jalur masuk

## 3. Implementasi dalam R
### **Koneksi ke Database MySQL**
Database dibuat dan dikelola menggunakan **R**, dengan koneksi ke MySQL melalui paket `DBI` dan `RMySQL`. Berikut adalah kode koneksi ke database:
```r
con <- dbConnect(MySQL(),
                 dbname = "K2JURUSAN",
                 host = "127.0.0.1",
                 port = 3306,
                 user = "root",
                 password = "")
```

### **Pembuatan Tabel di R**
Setiap tabel dibuat menggunakan perintah `dbExecute()`, misalnya:
```r
# Membuat tabel Wilayah
dbExecute(con, "CREATE TABLE IF NOT EXISTS Wilayah (
    id_wilayah INT PRIMARY KEY,
    Nama_Kabkota VARCHAR(255),
    nama_prov VARCHAR(255)
);")
```

### **Impor Data dari GitHub**
Data diambil langsung dari GitHub menggunakan `read.csv()` dan dimasukkan ke dalam tabel menggunakan `dbWriteTable()` atau `INSERT INTO`.
```r
url_universitas <- "https://raw.githubusercontent.com/deinov/MDS_K2_Database-Jurusan/main/data/UNIVERSITAS.csv"
universitas <- read.csv(url_universitas)
dbWriteTable(con, "Universitas", universitas, append = TRUE, row.names = FALSE)
```

## 4. Dashboard R Shiny
### **Fitur Dashboard**
Dashboard dibangun menggunakan **R Shiny** untuk menampilkan data dalam format **tabel interaktif** dan **grafik visualisasi**:
✅ **Menampilkan tabel dari database**
✅ **Visualisasi akreditasi universitas dan prodi**
✅ **Filter dan pencarian data**

### **Tampilan Dashboard**
Tampilan dashboard dibuat lebih elegan dengan tema `flatly`, serta warna yang berbeda untuk setiap kategori akreditasi.

### **Kode Dashboard R Shiny**
Dashboard dibuat menggunakan layout **sidebar + tabset panel**, dengan koneksi langsung ke MySQL.
```r
library(shiny)
library(DBI)
library(RMySQL)
library(ggplot2)
library(DT)
```
(Catatan: Kode lengkap dashboard dapat dilihat di file `shiny_dashboard.R`)

## Tim Penulis

Front-End Developer 


## 5. Kesimpulan
Proyek ini berhasil membangun **database K2JURUSAN** di MySQL, melakukan **impor data dari GitHub**, serta **menyajikan data dalam dashboard interaktif menggunakan R Shiny**. Sistem ini dapat digunakan untuk **analisis data perguruan tinggi, perbandingan daya tampung, serta distribusi akreditasi universitas dan program studi**.

## 6. Pengembangan Selanjutnya
Untuk pengembangan lebih lanjut, sistem ini dapat diperluas dengan fitur:
- **Analisis lebih dalam** tentang hubungan antara jumlah mahasiswa, akreditasi, dan daya tampung.
- **Penambahan fitur pencarian dan filter lanjutan** di dashboard.
- **Integrasi dengan API eksternal** untuk mendapatkan data terbaru secara otomatis.
Analisis lebih dalam tentang hubungan antara jumlah mahasiswa, akreditasi, dan daya tampung.
Penambahan fitur pencarian dan filter lanjutan di dashboard.
Integrasi dengan API eksternal untuk mendapatkan data terbaru secara otomatis.
