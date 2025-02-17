# Script Dashboard R Shiny

library(shiny)
library(DBI)
library(RMySQL)
library(ggplot2)
library(DT)
library(shinythemes)

# UI Dashboard dengan tema elegan
ui <- fluidPage(
  theme = shinytheme("flatly"),
  titlePanel(h1("Jurusan Statistika di Indonesia", align = "center")),
  sidebarLayout(
    sidebarPanel(
      selectInput("tabel", "Pilih Tabel:", 
                  choices = c("Wilayah", "Universitas", "Prodi", "Jalur_Masuk")),
      actionButton("loadData", "Muat Data", class = "btn-primary")
    ),
    mainPanel(
      tabsetPanel(id = "tabselected",
                  tabPanel("Tabel Data", DTOutput("dataTable")),
                  tabPanel("Visualisasi",
                           conditionalPanel(
                             condition = "input.tabel == 'Jalur_Masuk'",
                             selectInput("id_univ", "Pilih Universitas:", choices = NULL),
                             selectInput("id_prodi", "Pilih Program Studi:", choices = NULL)
                           ),
                           plotOutput("plot", height = "500px"))
      )
    )
  )
)

# Server Dashboard
server <- function(input, output, session) {
  
  con <- dbConnect(MySQL(), dbname = "K2JURUSAN", host = "127.0.0.1", 
                   port = 3306, user = "root", password = "")
  
  observeEvent(input$tabel, {
    if (input$tabel == "Jalur_Masuk") {
      updateSelectInput(session, "id_univ", choices = dbGetQuery(con, "SELECT DISTINCT id_univ FROM Jalur_Masuk")$id_univ)
    }
  })
  
  observeEvent(input$id_univ, {
    if (!is.null(input$id_univ) && input$id_univ != "") {
      query <- sprintf("SELECT DISTINCT id_prodi FROM Jalur_Masuk WHERE id_univ = '%s'", input$id_univ)
      updateSelectInput(session, "id_prodi", choices = dbGetQuery(con, query)$id_prodi)
    }
  })
  
  data_reactive <- eventReactive(input$loadData, {
    query <- sprintf("SELECT * FROM %s;", input$tabel)
    dbGetQuery(con, query)
  })
  
  output$dataTable <- renderDT({
    datatable(data_reactive(), options = list(pageLength = 10, autoWidth = TRUE))
  })
  
  output$plot <- renderPlot({
    df <- data_reactive()
    
    if (input$tabel == "Universitas") {
      df$akred_univ <- factor(df$akred_univ, levels = c("U", "A", "B", "C"), ordered = TRUE)
      ggplot(df, aes(x = akred_univ)) +
        geom_bar(fill = "#3498db", color = "black") +
        theme_minimal() +
        labs(title = "Distribusi Akreditasi Universitas", x = "Akreditasi", y = "Jumlah") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16))
    } else if (input$tabel == "Prodi") {
      df$akred_prodi <- factor(df$akred_prodi, levels = c("U", "A", "B", "C"), ordered = TRUE)
      ggplot(df, aes(x = akred_prodi, fill = akred_prodi)) +
        geom_bar(color = "black") +
        scale_fill_manual(values = c("#e74c3c", "#f39c12", "#2ecc71", "#3498db")) +
        theme_minimal() +
        labs(title = "Distribusi Akreditasi Prodi", x = "Akreditasi", y = "Jumlah") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16))
    } else if (input$tabel == "Jalur_Masuk") {
      if (is.null(input$id_univ) || input$id_univ == "" || is.null(input$id_prodi) || input$id_prodi == "") {
        plot.new()
        text(0.5, 0.5, "Silakan pilih Universitas dan Prodi terlebih dahulu", cex = 1.5)
      } else {
        query <- sprintf("SELECT jalur_masuk, daya_tampung FROM Jalur_Masuk WHERE id_univ = '%s' AND id_prodi = '%s'", 
                         input$id_univ, input$id_prodi)
        df <- dbGetQuery(con, query)
        ggplot(df, aes(x = jalur_masuk, y = daya_tampung, fill = jalur_masuk)) +
          geom_bar(stat = "identity", color = "black") +
          theme_minimal() +
          labs(title = "Jumlah Daya Tampung per Jalur Masuk", x = "Jalur Masuk", y = "Daya Tampung") +
          theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16))
      }
    } else {
      plot.new()
      text(0.5, 0.5, "Tidak ada visualisasi untuk tabel ini", cex = 1.5)
    }
  })
  
  onStop(function() {
    dbDisconnect(con)
  })
}

shinyApp(ui = ui, server = server)
