# Load Packages
library(shiny)
library(shinydashboard)
library(DBI)
library(RMySQL)
library(DT)
library(ggplot2)
library(plotly)  # Tambahkan paket plotly
library(leaflet)

# Koneksi ke MySQL
con <- dbConnect(MySQL(), dbname = "K2JURUSAN", host = "127.0.0.1", 
                 port = 3306, user = "root", password = "")

# UI Dashboard
ui <- dashboardPage(
  dashboardHeader(title = "Dashboard Jurusan Statistika"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Beranda", tabName = "beranda", icon = icon("home")),
      menuItem("Wilayah", tabName = "wilayah", icon = icon("map")),
      menuItem("Universitas", tabName = "universitas", icon = icon("university")),
      menuItem("Program Studi", tabName = "prodi", icon = icon("book")),
      menuItem("Jalur Masuk", tabName = "jalur_masuk", icon = icon("sign-in-alt"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # Tab Beranda
      tabItem(tabName = "beranda",
              fluidRow(
                valueBoxOutput("total_universitas"),
                valueBoxOutput("total_prodi"),
                valueBoxOutput("total_mahasiswa")
              ),
              fluidRow(
                box(title = "Distribusi Akreditasi Universitas", 
                    plotlyOutput("akreditasi_univ_plot"), width = 6),  # Ganti plotOutput jadi plotlyOutput
                box(title = "Distribusi Akreditasi Program Studi", 
                    plotlyOutput("akreditasi_prodi_plot"), width = 6)  # Ganti plotOutput jadi plotlyOutput
              )
      ),
      
      # Tab Universitas
      tabItem(tabName = "universitas",
              fluidRow(
                box(title = "Tabel Universitas", DTOutput("tabel_universitas"), width = 12)
              ),
              fluidRow(
                box(title = "Distribusi Akreditasi Universitas", width = 6, 
                    plotlyOutput("bar_akreditasi_univ")),
                box(title = "Persentase Akreditasi Universitas", width = 6, 
                    plotlyOutput("pie_akreditasi_univ"))
              )
      ),
      # Tab Wilayah
      tabItem(tabName = "wilayah",
              fluidRow(
                box(title = "Data Wilayah", width = 6, 
                    DTOutput("tabel_wilayah")),
                box(title = "Grafik Kabupaten/Kota per Provinsi", width = 6, 
                    plotlyOutput("grafik_wilayah"))
              )
              
      ),
      
      # Tab Jalur Masuk
      tabItem(tabName = "jalur_masuk",
              fluidRow(
                box(title = "Pilih Universitas", width = 6,
                    selectInput("pilih_univ", "Universitas:", choices = NULL)
                ),
                box(title = "Total Daya Tampung", width = 6,
                    valueBoxOutput("total_daya_tampung"))
              ),
              fluidRow(
                box(title = "Data Jalur Masuk", width = 12, 
                    DTOutput("tabel_jalur"))
              ),
              fluidRow(
                box(title = "Grafik Daya Tampung per Jalur Masuk", width = 6, 
                    plotlyOutput("grafik_jalur")),
                box(title = "Persentase Daya Tampung per Jalur Masuk", width = 6, 
                    plotlyOutput("pie_jalur"))
              )
      ),
      
      # Tab Program Studi
      tabItem(tabName = "prodi",
              fluidRow(
                box(title = "Pilih Universitas", width = 6,
                    selectInput("pilih_univ_prodi", "Universitas:", choices = NULL)
                ),
                box(title = "Total Mahasiswa", width = 6,
                    valueBoxOutput("total_mahasiswa_prodi"))
              ),
              fluidRow(
                box(title = "Data Program Studi", width = 12, 
                    DTOutput("tabel_prodi"))
              ),
              fluidRow(
                box(title = "Jumlah Mahasiswa per Program Studi", width = 6, 
                    plotlyOutput("grafik_mahasiswa")),
                box(title = "Jumlah Dosen per Program Studi", width = 6, 
                    plotlyOutput("grafik_dosen"))
              ),
              fluidRow(
                box(title = "Persentase Akreditasi Program Studi", width = 6, 
                    plotlyOutput("pie_akreditasi"))
              )
      )
    )
  )
)
# Server Dashboard
server <- function(input, output, session) {
  
  # Ambil jumlah universitas, prodi, dan mahasiswa
  output$total_universitas <- renderValueBox({
    total <- dbGetQuery(con, "SELECT COUNT(DISTINCT id_univ) AS total FROM Universitas")$total
    valueBox(total, "Total Universitas", icon = icon("university"), color = "blue")
  })
  
  output$total_prodi <- renderValueBox({
    total <- dbGetQuery(con, "SELECT COUNT(DISTINCT id_prodi) AS total FROM Prodi")$total
    valueBox(total, "Total Program Studi", icon = icon("book"), color = "green")
  })
  
  output$total_mahasiswa <- renderValueBox({
    total <- dbGetQuery(con, "SELECT SUM(jumlah_mahasiswa) AS total FROM Prodi")$total
    valueBox(total, "Total Mahasiswa", icon = icon("users"), color = "red")
  })
  
  # Visualisasi Akreditasi Universitas dalam 3D
  output$akreditasi_univ_plot <- renderPlotly({
    df <- dbGetQuery(con, "SELECT akred_univ FROM Universitas")
    df_count <- as.data.frame(table(df$akred_univ))
    
    plot_ly(df_count, x = ~Var1, y = ~Freq, z = ~Freq, type = "bar", color = ~Var1) %>%
      layout(
        title = "Distribusi Akreditasi Universitas (3D)",
        scene = list(
          xaxis = list(title = "Akreditasi"),
          yaxis = list(title = "Jumlah"),
          zaxis = list(title = "Frekuensi")
        )
      )
  })
  
  # Visualisasi Akreditasi Program Studi dalam 3D
  output$akreditasi_prodi_plot <- renderPlotly({
    df <- dbGetQuery(con, "SELECT akred_prodi FROM Prodi")
    df_count <- as.data.frame(table(df$akred_prodi))
    
    plot_ly(df_count, x = ~Var1, y = ~Freq, z = ~Freq, type = "bar", color = ~Var1) %>%
      layout(
        title = "Distribusi Akreditasi Program Studi (3D)",
        scene = list(
          xaxis = list(title = "Akreditasi"),
          yaxis = list(title = "Jumlah"),
          zaxis = list(title = "Frekuensi")
        )
      )
  })
  
  # Ambil Data Wilayah dari Database
  wilayah_data <- reactive({
    dbGetQuery(con, "SELECT id_wilayah, Nama_Kabkota, nama_prov FROM Wilayah")
  })
  
  # Tabel Data Wilayah
  output$tabel_wilayah <- renderDT({
    datatable(wilayah_data(), options = list(pageLength = 5))
  })
  
  # Grafik Distribusi Kabupaten/Kota per Provinsi
  output$grafik_wilayah <- renderPlotly({
    data <- wilayah_data() %>%
      group_by(nama_prov) %>%
      summarise(jumlah_kabkota = n())
    
    plot_ly(data, x = ~nama_prov, y = ~jumlah_kabkota, type = "bar", color = ~nama_prov) %>%
      layout(title = "Jumlah Kabupaten/Kota per Provinsi",
             xaxis = list(title = "Provinsi"),
             yaxis = list(title = "Jumlah Kabupaten/Kota"))
  })
  
  # Pie Chart Persentase Kabupaten/Kota per Provinsi
  output$pie_wilayah <- renderPlotly({
    data <- wilayah_data() %>%
      group_by(nama_prov) %>%
      summarise(jumlah_kabkota = n())
    
    plot_ly(data, labels = ~nama_prov, values = ~jumlah_kabkota, type = "pie", textinfo = "label+percent") %>%
      layout(title = "Persentase Kabupaten/Kota per Provinsi")
  })
  
  # Word Cloud Nama Kabupaten/Kota
  output$wordcloud_wilayah <- renderPlot({
    library(wordcloud)
    data <- wilayah_data()
    
    wordcloud(words = data$Nama_Kabkota, scale = c(3, 0.5), max.words = 50, colors = rainbow(7))
  })
  
  # Ambil Data Universitas dari Database
  universitas_data <- reactive({
    dbGetQuery(con, "SELECT * FROM Universitas")
  })
  
  # Tampilkan Tabel Universitas
  output$tabel_universitas <- renderDT({
    datatable(universitas_data(), options = list(pageLength = 5))
  })
  
  # Grafik Distribusi Akreditasi Universitas (Bar Chart)
  output$bar_akreditasi_univ <- renderPlotly({
    df <- dbGetQuery(con, "SELECT akred_univ FROM Universitas")
    df_count <- as.data.frame(table(df$akred_univ))
    
    plot_ly(df_count, x = ~Var1, y = ~Freq, type = "bar", color = ~Var1) %>%
      layout(
        title = "Distribusi Akreditasi Universitas",
        xaxis = list(title = "Akreditasi"),
        yaxis = list(title = "Jumlah")
      )
  })
  
  # Pie Chart Persentase Akreditasi Universitas
  output$pie_akreditasi_univ <- renderPlotly({
    df <- dbGetQuery(con, "SELECT akred_univ FROM Universitas")
    df_count <- as.data.frame(table(df$akred_univ))
    
    plot_ly(df_count, labels = ~Var1, values = ~Freq, type = "pie", textinfo = "label+percent") %>%
      layout(title = "Persentase Akreditasi Universitas")
  })
  # Ambil Data Jalur Masuk dari Database
  jalur_data <- reactive({
    dbGetQuery(con, "SELECT id_prodi, id_univ, jalur_masuk, daya_tampung, website FROM jalur_masuk")
  })
  
  # Perbarui Pilihan Universitas dalam Dropdown
  observe({
    data <- jalur_data()
    updateSelectInput(session, "pilih_univ", choices = unique(data$id_univ))
  })
  
  # Filter Data Berdasarkan Universitas yang Dipilih
  data_filtered <- reactive({
    data <- jalur_data()
    if (!is.null(input$pilih_univ)) {
      data <- data %>% filter(id_univ == input$pilih_univ)
    }
    return(data)
  })
  
  # Tampilkan Tabel Jalur Masuk
  output$tabel_jalur <- renderDT({
    datatable(data_filtered(), options = list(pageLength = 5))
  })
  
  # Hitung Total Daya Tampung
  output$total_daya_tampung <- renderValueBox({
    total <- sum(data_filtered()$daya_tampung, na.rm = TRUE)
    valueBox(total, "Total Daya Tampung", icon = icon("users"), color = "blue")
  })
  
  # Grafik Daya Tampung per Jalur Masuk
  output$grafik_jalur <- renderPlotly({
    data <- data_filtered() %>%
      group_by(jalur_masuk) %>%
      summarise(total_daya_tampung = sum(daya_tampung))
    
    plot_ly(data, x = ~jalur_masuk, y = ~total_daya_tampung, type = "bar", color = ~jalur_masuk) %>%
      layout(title = "Daya Tampung per Jalur Masuk",
             xaxis = list(title = "Jalur Masuk"),
             yaxis = list(title = "Total Daya Tampung"))
  })
  
  # Pie Chart Persentase Jalur Masuk
  output$pie_jalur <- renderPlotly({
    data <- data_filtered() %>%
      group_by(jalur_masuk) %>%
      summarise(total_daya_tampung = sum(daya_tampung))
    
    plot_ly(data, labels = ~jalur_masuk, values = ~total_daya_tampung, type = "pie", textinfo = "label+percent") %>%
      layout(title = "Persentase Daya Tampung per Jalur Masuk")
  })
  
  
  # Ambil Data Program Studi dari Database
  prodi_data <- reactive({
    dbGetQuery(con, "SELECT id_prodi, id_univ, nama_prodi, jumlah_dosen, jumlah_mahasiswa, akred_prodi, jenjang FROM prodi")
  })
  
  # Perbarui Pilihan Universitas dalam Dropdown
  observe({
    data <- prodi_data()
    updateSelectInput(session, "pilih_univ_prodi", choices = unique(data$id_univ))
  })
  
  # Filter Data Berdasarkan Universitas yang Dipilih
  data_filtered_prodi <- reactive({
    data <- prodi_data()
    if (!is.null(input$pilih_univ_prodi)) {
      data <- data %>% filter(id_univ == input$pilih_univ_prodi)
    }
    return(data)
  })
  
  # Tampilkan Tabel Program Studi
  output$tabel_prodi <- renderDT({
    datatable(data_filtered_prodi(), options = list(pageLength = 5))
  })
  
  # Hitung Total Mahasiswa
  output$total_mahasiswa_prodi <- renderValueBox({
    total <- sum(data_filtered_prodi()$jumlah_mahasiswa, na.rm = TRUE)
    valueBox(total, "Total Mahasiswa", icon = icon("users"), color = "blue")
  })
  
  # Grafik Jumlah Mahasiswa per Program Studi
  output$grafik_mahasiswa <- renderPlotly({
    data <- data_filtered_prodi() %>%
      arrange(desc(jumlah_mahasiswa)) %>%
      head(10)  # Ambil 10 prodi teratas berdasarkan jumlah mahasiswa
    
    plot_ly(data, x = ~nama_prodi, y = ~jumlah_mahasiswa, type = "bar", color = ~nama_prodi) %>%
      layout(title = "Jumlah Mahasiswa per Program Studi",
             xaxis = list(title = "Program Studi", tickangle = -45),
             yaxis = list(title = "Jumlah Mahasiswa"))
  })
  
  # Grafik Jumlah Dosen per Program Studi
  output$grafik_dosen <- renderPlotly({
    data <- data_filtered_prodi() %>%
      arrange(desc(jumlah_dosen)) %>%
      head(10)  # Ambil 10 prodi teratas berdasarkan jumlah dosen
    
    plot_ly(data, x = ~nama_prodi, y = ~jumlah_dosen, type = "bar", color = ~nama_prodi) %>%
      layout(title = "Jumlah Dosen per Program Studi",
             xaxis = list(title = "Program Studi", tickangle = -45),
             yaxis = list(title = "Jumlah Dosen"))
  })
  
  # Pie Chart Persentase Akreditasi Program Studi
  output$pie_akreditasi <- renderPlotly({
    data <- data_filtered_prodi() %>%
      group_by(akred_prodi) %>%
      summarise(jumlah_prodi = n())
    
    plot_ly(data, labels = ~akred_prodi, values = ~jumlah_prodi, type = "pie", textinfo = "label+percent") %>%
      layout(title = "Persentase Akreditasi Program Studi")
  })
  
  
  # Disconnect dari database saat aplikasi ditutup
  onStop(function() {
    dbDisconnect(con)
  })
}

# Run Shiny App
shinyApp(ui = ui, server = server)
