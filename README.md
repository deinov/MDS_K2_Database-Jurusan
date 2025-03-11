# MDS_K2_Database-Jurusan
![Image](https://github.com/user-attachments/assets/4586966d-c39b-49b7-b5f1-faca06320033)

## **Role**
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


## **Pendahuluan**  

   Pendidikan tinggi di Indonesia memiliki keragaman yang tinggi, baik dari segi jumlah universitas, program studi, maupun jalur masuk yang ditawarkan. Namun, informasi ini seringkali tersebar di berbagai sumber dan tidak terintegrasi dengan baik. Hal ini menyulitkan calon mahasiswa, peneliti, atau pemangku kebijakan dalam mengakses dan menganalisis data secara efektif. Oleh karena itu, dibutuhkan sistem database yang terpusat dan terstruktur untuk mengintegrasikan data tersebut, serta menyajikannya dalam bentuk yang mudah dipahami.

   Di era digital yang semakin didorong oleh data, pengelolaan informasi perguruan tinggi yang efisien dan terstruktur menjadi kunci penting dalam mendukung pengambilan keputusan yang akurat dan berbasis data. Data seperti lokasi wilayah, informasi universitas, program studi (prodi), dan jalur masuk merupakan aset berharga yang perlu disimpan, diolah, dan disajikan dengan baik. Sistem database yang terstruktur tidak hanya memudahkan penyimpanan data, tetapi juga memungkinkan analisis mendalam dan visualisasi interaktif yang dapat membantu berbagai pihak, mulai dari calon mahasiswa, peneliti, hingga pemangku kebijakan.

   Proyek ini bertujuan untuk membangun sistem database yang komprehensif dan interaktif, khususnya untuk jurusan Statistika di Indonesia. Dengan menyediakan informasi tentang universitas, program studi, akreditasi, daya tampung, dan jalur masuk, sistem ini dirancang untuk menjadi alat bantu yang efektif dalam menganalisis dan membandingkan data perguruan tinggi. Selain itu, sistem ini juga dilengkapi dengan dashboard interaktif yang memungkinkan pengguna untuk mengeksplorasi data secara visual dan dinamis.

### **Tujuan Proyek**  
Proyek ini memiliki beberapa tujuan utama:  
1. **Membangun Database Terstruktur**: Menyimpan data tentang wilayah, universitas, program studi, dan jalur masuk dalam sistem database yang terstruktur dan efisien.  
2. **Menyediakan Akses Data yang Mudah**: Memungkinkan pengguna untuk mengakses dan menganalisis data dengan cepat melalui antarmuka yang user-friendly.  
3. **Visualisasi Data Interaktif**: Menyajikan data dalam bentuk dashboard interaktif yang dilengkapi dengan grafik, tabel, dan filter dinamis.  

### **Teknologi yang Digunakan**  
Untuk mencapai tujuan tersebut, proyek ini memanfaatkan beberapa teknologi dan tools yang saling melengkapi:  

1. **Database**:  
   - **MySQL (via dbngin)**: Digunakan sebagai sistem manajemen database relasional untuk menyimpan data secara terstruktur dan efisien. MySQL dipilih karena kemampuannya dalam menangani data besar dan kompatibilitasnya dengan berbagai tools analisis.  
   - **R (RMySQL dan DBI package)**: Digunakan untuk menghubungkan R dengan MySQL, membuat tabel, dan melakukan impor data ke dalam database. Paket ini memastikan integrasi yang mulus antara R dan MySQL.  

2. **Pengolahan Data**:  
   - **R (tidyverse, dplyr, readr, DBI)**: Digunakan untuk pembersihan data, manipulasi, dan transformasi data sebelum dimasukkan ke dalam database. Paket-paket ini memastikan data yang diolah konsisten, akurat, dan siap digunakan untuk analisis lebih lanjut.  

3. **Visualisasi & Dashboard**:  
   - **R Shiny**: Digunakan untuk membangun antarmuka pengguna interaktif yang memungkinkan eksplorasi data perguruan tinggi melalui grafik, tabel, dan filter dinamis. Dashboard ini dirancang untuk memberikan pengalaman pengguna yang intuitif dan informatif, sehingga pengguna dapat dengan mudah mengekstrak insight dari data.  

Dengan menggabungkan kekuatan database, pengolahan data, dan visualisasi interaktif, proyek ini bertujuan untuk menciptakan sistem yang tidak hanya menyimpan data dengan baik, tetapi juga menyajikannya dalam bentuk yang mudah dipahami dan dapat diakses oleh berbagai pihak.

## **Entity Relationship Diagram (ERD)**
![ERD Novel](https://github.com/deinov/MDS_K2_Database-Jurusan/blob/main/Image/ERD%20Baru.jpg)

Entity Relationship Diagram (ERD) yang menjelaskan hubungan antar entitas dalam sistem. Berikut interpretasinya:

1. Entitas WILAYAH <br>
Hubungan:  <br>
One to Many (1:N) dengan UNIVERSITAS, artinya *satu wilayah memiliki banyak universitas*.

2. Entitas UNIVERSITAS <br>
Hubungan: <br>
One to Many (1:N) dengan PRODI, artinya *satu universitas memiliki banyak program studi*.
Many to Many (N:M) dengan JALUR MASUK dan atribut "website" menjadi Relation Entity, artinya *satu universitas memiliki beberapa jalur masuk, dan satu jalur masuk bisa digunakan oleh beberapa universitas*.

3. Entitas PRODI <br>
Hubungan: <br>
One to Many (1:N) dengan UNIVERSITAS, artinya *banyak program studi berada di satu universitas*.
Many to Many (N:M) dengan JALUR MASUK dan "daya tampung" menjadi Relation Entity, artinya *banyak program studi bisa memiliki banyak jalur masuk*. <br>

*catatan*: <br>
1. Penambahan Atribut <br>
Terdapat penambahan atribut pada entitas Universitas dan Jalur masuk. Pada Entitas `Universitas` ditambahkan atribut `longitude` dan `latitude` untuk tujuan visualisasi data di RShiny, sedangkan penambahan pada entitas `Jalur masuk` adalah atribut `id_jalur` karena pada entitas tersebut tidak terdapat Primary key atau kode yang unik, untuk menghindari adanya redudansi serta anomali maka dilakukan penambahan atribut yaitu `id_jalur` sebagai primay key dari `jalur masuk`.

3. Temuan (Anomali) <br>
Pada data `jalur masuk`, ditemukan duplikasi data dimana terdapat dua tuple/baris yang sama persis tanpa perbedaan maka perlu dilakukan penghapusan pada salah satu tuple karena berdasarkan hasil analisis kelompok dicurigai tersapat kesalahan input data manual.

## **Struktur Database**
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
- - `latitude` (DECIMAL) - Latitude
- `longitude` (DECIMAL) - Longitude 

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

## **Implementasi dalam R**
### Koneksi ke Database MySQL
Database dibuat dan dikelola menggunakan **R**, dengan koneksi ke MySQL melalui paket `DBI` dan `RMySQL`. Berikut adalah kode koneksi ke database:
```r
con <- dbConnect(MySQL(),
                 dbname = "K2JURUSAN",
                 host = "127.0.0.1",
                 port = 3306,
                 user = "root",
                 password = "")
```

### Pembuatan Tabel di R
Setiap tabel dibuat menggunakan perintah `dbExecute()`, misalnya:
```r
# Membuat tabel Wilayah
dbExecute(con, "CREATE TABLE IF NOT EXISTS Wilayah (
    id_wilayah INT PRIMARY KEY,
    Nama_Kabkota VARCHAR(255),
    nama_prov VARCHAR(255)
);")
```

### Impor Data dari GitHub
Data diambil langsung dari GitHub menggunakan `read.csv()` dan dimasukkan ke dalam tabel menggunakan `dbWriteTable()` atau `INSERT INTO`.
```r
url_universitas <- "https://raw.githubusercontent.com/deinov/MDS_K2_Database-Jurusan/main/data/UNIVERSITAS.csv"
universitas <- read.csv(url_universitas)
dbWriteTable(con, "Universitas", universitas, append = TRUE, row.names = FALSE)
```

## **Dashboard R Shiny**
### Fitur Dashboard  <br>
Dashboard dibangun menggunakan **R Shiny** untuk menampilkan data dalam format **tabel interaktif** dan **grafik visualisasi**: 

✅ **Menampilkan tabel dari database**  
✅ **Visualisasi akreditasi universitas dan prodi**  
✅ **Filter dan pencarian data** 

### Tampilan Dashboard
![Image](https://github.com/user-attachments/assets/fcc54727-9c2c-46e6-9df7-e0346dca8514)
**Menu


✅ **Wilayah

✅ **Universitas

✅ **Program Studi

✅ **Jalur Masuk

✅ **Our Team

Tampilan dashboard dibuat lebih elegan dengan tema `flatly`, serta warna yang berbeda untuk setiap kategori akreditasi.

### Kode Dashboard R Shiny
Dashboard dibuat menggunakan layout **sidebar + tabset panel**, dengan koneksi langsung ke MySQL.
```r
library(shiny)
library(DBI)
library(RMySQL)
library(ggplot2)
library(DT)
```
(Catatan: Kode lengkap dashboard dapat dilihat di file `shiny_dashboard.R`)

## **Kesimpulan**

Tugas ini bertujuan untuk membangun sebuah database yang menyimpan informasi lengkap tentang jurusan Statistika di Indonesia. Database ini dirancang untuk mencakup empat entitas utama: **Wilayah**, **Universitas**, **Program Studi**, dan **Jalur Masuk**. Masing-masing entitas memiliki atribut yang dirancang untuk memenuhi kebutuhan analisis data dan visualisasi yang komprehensif.  

1. **Entitas Wilayah**
   ![Image](https://github.com/user-attachments/assets/c550ed39-cb4c-48fe-8a7e-6022a7d417d8)
   Entitas ini berisi informasi tentang lokasi geografis, seperti `id_wilayah`, `nama_kabupaten_kota`, dan `nama_provinsi`. Data ini membantu dalam mengelompokkan universitas dan program studi berdasarkan daerah, memudahkan analisis distribusi geografis.  

2. **Entitas Universitas**
   ![Image](https://github.com/user-attachments/assets/8071eb16-442d-40e0-b062-0939b65631ec)
   Entitas universitas menyimpan data seperti `id_univ`, `id_wilayah`, `nama_univ`, `akreditasi_univ`, serta atribut baru yaitu `longitude` dan `latitude`. Atribut geospasial ini memungkinkan visualisasi data universitas dalam bentuk peta interaktif pada dashboard, memberikan perspektif spasial yang lebih menarik.  

3. **Entitas Program Studi**
   ![Image](https://github.com/user-attachments/assets/1fde6d4d-173e-4c48-ac7b-1beef06f10fe)
   Entitas ini berfokus pada program studi Statistika, dengan atribut seperti `id_prodi`, `jenjang`, `id_univ`, `nama_prodi`, `jumlah_dosen`, `jumlah_mahasiswa`, dan `akreditasi_prodi`. Data ini memungkinkan analisis mendalam tentang kualitas dan kapasitas program studi di berbagai universitas.  

4. **Entitas Jalur Masuk**
   ![Image](https://github.com/user-attachments/assets/c5801751-3808-41f4-bf26-95cb977e6215)
   Entitas jalur masuk mencatat informasi seperti `id_jalur`, `id_univ`, `id_prodi`, `website`, `daya_tampung`, dan `jalur_masuk`. Atribut `id_jalur` ditambahkan sebagai kode unik untuk menghindari anomali dan redundansi data. Entitas ini membantu dalam memahami variasi jalur penerimaan mahasiswa dan kapasitas penerimaan di setiap program studi.  

Hasil dari proyek ini adalah sebuah database yang menyediakan informasi lengkap tentang jurusan Statistika di Indonesia, mencakup berbagai universitas, daerah, dan jalur masuk. Database ini tidak hanya berguna untuk analisis data, tetapi juga dapat menjadi alat bantu bagi calon mahasiswa, peneliti, dan pemangku kebijakan dalam mengambil keputusan terkait pendidikan tinggi.  

Dengan adanya fitur visualisasi data seperti peta interaktif dan dashboard yang user-friendly, sistem ini memberikan pengalaman pengguna yang lebih baik dan memudahkan eksplorasi data. Proyek ini juga membuka peluang untuk pengembangan lebih lanjut, seperti integrasi dengan API eksternal, penambahan fitur analisis prediktif, dan perluasan cakupan data untuk memberikan insight yang lebih mendalam.  

## **Pengembangan Selanjutnya**
Untuk pengembangan lebih lanjut, sistem ini dapat diperluas dengan fitur:
- **Analisis lebih dalam** tentang hubungan antara jumlah mahasiswa, akreditasi, dan daya tampung.
- **Penambahan fitur pencarian dan filter lanjutan** di dashboard.
- **Integrasi dengan API eksternal** untuk mendapatkan data terbaru secara otomatis.
Analisis lebih dalam tentang hubungan antara jumlah mahasiswa, akreditasi, dan daya tampung.
Penambahan fitur pencarian dan filter lanjutan di dashboard.
Integrasi dengan API eksternal untuk mendapatkan data terbaru secara otomatis.

Team
![Image](https://github.com/user-attachments/assets/dec3d289-5f08-4170-9090-51943bbdc936)
Zamrah Mumainah M0501241066

Jefita Resti Sari M0501241031

Claudian T. Tangdilomban M0501241048

I Putu Gde Inove Bagus Prasetya M0501241084

Carlya Agmis Aimandiga M0501241089
