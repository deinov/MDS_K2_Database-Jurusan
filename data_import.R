# Script Import Data dari GitHub ke MySQL

library(DBI)
library(RMySQL)
library(dplyr)

# Koneksi ke database K2JURUSAN
con <- dbConnect(MySQL(), 
                 dbname = "K2JURUSAN", 
                 host = "127.0.0.1", 
                 port = 3306, 
                 user = "root", 
                 password = "")

# URL dataset dari GitHub
url_universitas <- "https://raw.githubusercontent.com/deinov/MDS_K2_Database-Jurusan/main/data/UNIVERSITAS.csv"
url_wilayah <- "https://raw.githubusercontent.com/deinov/MDS_K2_Database-Jurusan/main/data/wilayah.csv"
url_prodi <- "https://raw.githubusercontent.com/deinov/MDS_K2_Database-Jurusan/main/data/Prodi%20StatHub.csv"
url_jalur_masuk <- "https://raw.githubusercontent.com/deinov/MDS_K2_Database-Jurusan/main/data/jalur%20masuk1.csv"

# Membaca dataset dari GitHub
universitas <- read.csv(url_universitas)
wilayah <- read.csv(url_wilayah)
prodi <- read.csv(url_prodi)
jalur_masuk <- read.csv(url_jalur_masuk)

# Sesuaikan data sebelum diinsert
universitas <- universitas %>% select(id_univ, id_wilayah, nama_univ, akred_univ)
wilayah <- wilayah %>% select(id_wilayah, Nama_Kabkota, nama_prov)
prodi <- prodi %>% select(id_prodi, id_univ, nama_prodi, jumlah_dosen, jumlah_mahasiswa, akred_prodi, jenjang)
jalur_masuk <- jalur_masuk %>% select(id_prodi, id_univ, jalur_masuk, daya_tampung, website)

# Fungsi untuk memasukkan data ke database dengan aman
insert_data_safe <- function(con, table_name, data) {
  for (i in 1:nrow(data)) {
    query <- sprintf("INSERT IGNORE INTO %s (%s) VALUES (%s);",
                     table_name,
                     paste(colnames(data), collapse = ", "),
                     paste0("'", data[i, ], "'", collapse = ", "))
    tryCatch({
      dbExecute(con, query)
    }, error = function(e) {
      message(paste("⚠️ Gagal memasukkan data ke", table_name, ":", e$message))
    })
  }
  message(paste("✅ Data berhasil ditambahkan ke tabel", table_name))
}

# Import data ke MySQL
insert_data_safe(con, "Wilayah", wilayah)
insert_data_safe(con, "Universitas", universitas)
insert_data_safe(con, "Prodi", prodi)
insert_data_safe(con, "Jalur_Masuk", jalur_masuk)

# Tutup koneksi database
dbDisconnect(con)
