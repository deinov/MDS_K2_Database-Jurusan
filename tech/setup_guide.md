# Panduan Menjalankan Proyek K2JURUSAN

## 1. Persiapan Awal
Sebelum menjalankan proyek, pastikan Anda memiliki:
- **R dan RStudio**
- **MySQL** (melalui dbngin atau server MySQL lainnya)
- **Git** (jika ingin mengunduh dari GitHub)
- Koneksi internet untuk mengambil data dari GitHub

## 2. Clone Repository dari GitHub
Jika Anda ingin menjalankan proyek ini di komputer lain, clone repository ini terlebih dahulu:
```bash
git clone https://github.com/deinov/MDS_K2_Database-Jurusan.git
cd MDS_K2_Database-Jurusan
```

## 3. Instalasi Library yang Dibutuhkan
Pastikan semua package R yang diperlukan sudah diinstal:
```r
install.packages(c("DBI", "RMySQL", "dplyr", "ggplot2", "DT", "shiny", "shinythemes"))
```

## 4. Jalankan Skrip Pembuatan Database
Buka **RStudio** dan jalankan:
```r
source("database_setup.R")
```

💡 **Cek apakah database dan tabel sudah ada di MySQL dengan perintah berikut:**
```r
library(DBI)
library(RMySQL)
con <- dbConnect(MySQL(), dbname = "K2JURUSAN", host = "127.0.0.1", port = 3306, user = "root", password = "")
dbGetQuery(con, "SHOW TABLES;")  # Pastikan tabel sudah ada
dbDisconnect(con)
```

## 5. Jalankan Skrip Import Data
```r
source("data_import.R")
```
💡 **Cek apakah data sudah masuk ke MySQL dengan perintah berikut:**
```r
con <- dbConnect(MySQL(), dbname = "K2JURUSAN", host = "127.0.0.1", port = 3306, user = "root", password = "")
dbGetQuery(con, "SELECT COUNT(*) FROM Universitas;")  # Cek jumlah data di tabel Universitas
dbDisconnect(con)
```

## 6. Jalankan Dashboard R Shiny
```r
shiny::runApp("shiny_dashboard.R")
```
📌 **Aplikasi akan terbuka di browser, dan Anda bisa mulai eksplorasi datanya!**

## 7. Troubleshooting
Jika mengalami kendala, pastikan:
- MySQL berjalan dan database sudah dibuat
- Paket R yang diperlukan sudah diinstal
- Tidak ada error saat menjalankan skrip R

🚀 **Sekarang proyek Anda sudah berjalan! Nikmati eksplorasi data K2JURUSAN!**

