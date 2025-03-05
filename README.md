# MDS_K2_Database-Jurusan
![Image](https://github.com/user-attachments/assets/4586966d-c39b-49b7-b5f1-faca06320033)

## 1. Pendahuluan
Dalam era digital, pengelolaan data perguruan tinggi yang efisien sangat penting untuk mendukung pengambilan keputusan yang berbasis data. Data terkait wilayah, universitas, program studi (prodi), dan jalur masuk perlu disimpan dalam suatu sistem database yang terstruktur, mudah diakses, dan dapat divisualisasikan secara interaktif.

Teknologi yang digunakan :
- Database:
- MySQL (via dbngin) → Digunakan untuk menyimpan data secara terstruktur.
- R (RMySQL dan DBI package) → Untuk koneksi ke database, pembuatan tabel, dan impor data.

Pengolahan Data:
- R (tidyverse, dplyr, readr, DBI) → Digunakan untuk pembersihan, manipulasi, dan transformasi data sebelum dimasukkan ke dalam database.

Visualisasi & Dashboard:
- R Shiny → Untuk membangun antarmuka pengguna interaktif yang memungkinkan eksplorasi data perguruan tinggi dalam bentuk grafik, tabel, dan filter dinamis.

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

### Diagram ER
![ERD Novel](https://github.com/deinov/MDS_K2_Database-Jurusan/blob/Designer-DB/ERD.jpg)

Entity Relationship Diagram (ERD) yang menjelaskan hubungan antar entitas dalam sistem. Berikut interpretasinya:

1. Entitas WILAYAH
Hubungan: One to Many (1:N) dengan UNIVERSITAS, artinya *satu wilayah memiliki banyak universitas*.

2. Entitas UNIVERSITAS
Hubungan:
One to Many (1:N) dengan PRODI, artinya *satu universitas memiliki banyak program studi*.
Many to Many (N:M) dengan JALUR MASUK dan atribut "website" menjadi Relation Entity, artinya *satu universitas memiliki beberapa jalur masuk, dan satu jalur masuk bisa digunakan oleh beberapa universitas*.

3. Entitas PRODI
Hubungan:
One to Many (1:N) dengan UNIVERSITAS, artinya *banyak program studi berada di satu universitas*.
Many to Many (N:M) dengan JALUR MASUK dan "daya tampung" menjadi Relation Entity, artinya *banyak program studi bisa memiliki banyak jalur masuk*.

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

## Tim Penulis dan masing-masiing role

1. **Designer DB (Zamrah Mutmainah)**  
   Bertanggung jawab untuk menganalisis kebutuhan data, merancang skema database (termasuk tabel, relasi, dan indeks), serta memastikan integritas data dan keamanan sistem. Peran ini krusial dalam menciptakan fondasi database yang efisien dan terstruktur untuk mendukung kebutuhan aplikasi.

2. **Back-End Developer (Jefita Resti Sari)**  
   Mengelola logika server, integrasi database, dan API. Memastikan bahwa data dapat diakses dan diproses dengan baik oleh front-end. Peran ini juga bertanggung jawab atas keamanan dan performa sistem secara keseluruhan.

3. **DB Manager (I Putu Gde Inove Bagus Prasetya)**  
   Bertugas mengelola dan memelihara database, termasuk optimasi query, backup data, dan memastikan ketersediaan data. Peran ini memastikan database berjalan lancar dan siap digunakan oleh tim pengembang.

4. **Front-End Developer (Claudian Tikulimbong Tangdilomban)**  
   Fokus pada desain UI (User Interface), interaktivitas dengan pengguna, visualisasi data, dan optimasi UI/UX. Juga bertanggung jawab untuk testing dan debugging antarmuka agar pengguna dapat berinteraksi dengan sistem secara intuitif dan menyenangkan.

5. **Technical Writer (Carlya Agmis Aimandiga)**  
   Menyusun dokumentasi teknis, termasuk panduan penggunaan, visualisasi header, dan mengelola knowledge base untuk tim dan pengguna. Peran ini memastikan bahwa semua informasi tentang sistem terdokumentasi dengan baik dan mudah dipahami.


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
