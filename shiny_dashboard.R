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
                 port = 3307, user = "root", password = "")

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
      
      # Tab Wilayah
      tabItem(tabName = "wilayah",
              fluidRow(
                box(title = "Data Wilayah", width = 6, 
                    DTOutput("tabel_wilayah")),
                box(title = "Grafik Kabupaten/Kota per Provinsi", width = 6, 
                    plotlyOutput("grafik_wilayah"))
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
  
  # Disconnect dari database saat aplikasi ditutup
  onStop(function() {
    dbDisconnect(con)
  })
}

# Run Shiny App
shinyApp(ui = ui, server = server)