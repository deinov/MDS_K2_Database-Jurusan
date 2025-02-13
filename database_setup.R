# Script Pembuatan Database dan Tabel MySQL di R

library(DBI)
library(RMySQL)

# Koneksi ke MySQL (tanpa memilih database terlebih dahulu)
con <- dbConnect(MySQL(), 
                 host = "127.0.0.1", 
                 port = 3306, 
                 user = "root", 
                 password = "")  # Sesuaikan jika ada password

# Buat Database K2JURUSAN jika belum ada
dbExecute(con, "CREATE DATABASE IF NOT EXISTS K2JURUSAN;")

# Tutup koneksi sementara
dbDisconnect(con)

# Koneksi ulang ke database K2JURUSAN
con <- dbConnect(MySQL(), 
                 dbname = "K2JURUSAN", 
                 host = "127.0.0.1", 
                 port = 3306, 
                 user = "root", 
                 password = "")

# Membuat tabel di MySQL

# Tabel Wilayah
dbExecute(con, "CREATE TABLE IF NOT EXISTS Wilayah (
    id_wilayah INT PRIMARY KEY,
    Nama_Kabkota VARCHAR(255),
    nama_prov VARCHAR(255)
);")

# Tabel Universitas
dbExecute(con, "CREATE TABLE IF NOT EXISTS Universitas (
    id_univ INT PRIMARY KEY AUTO_INCREMENT,
    id_wilayah INT,
    nama_univ VARCHAR(255) NOT NULL,
    akred_univ CHAR(1),
    FOREIGN KEY (id_wilayah) REFERENCES Wilayah(id_wilayah) ON DELETE SET NULL
);")

# Tabel Prodi
dbExecute(con, "CREATE TABLE IF NOT EXISTS Prodi (
    id_prodi INT PRIMARY KEY AUTO_INCREMENT,
    id_univ INT,
    nama_prodi VARCHAR(255) NOT NULL,
    jumlah_dosen INT,
    jumlah_mahasiswa INT,
    akred_prodi CHAR(1),
    jenjang VARCHAR(50),
    FOREIGN KEY (id_univ) REFERENCES Universitas(id_univ) ON DELETE CASCADE
);")

# Tabel Jalur Masuk
dbExecute(con, "CREATE TABLE IF NOT EXISTS Jalur_Masuk (
    id_jalur INT PRIMARY KEY AUTO_INCREMENT,
    id_prodi INT,
    id_univ INT,
    jalur_masuk VARCHAR(255) NOT NULL,
    daya_tampung INT,
    website VARCHAR(255),
    FOREIGN KEY (id_prodi) REFERENCES Prodi(id_prodi) ON DELETE CASCADE,
    FOREIGN KEY (id_univ) REFERENCES Universitas(id_univ) ON DELETE CASCADE
);")

# Tutup koneksi database
dbDisconnect(con)
