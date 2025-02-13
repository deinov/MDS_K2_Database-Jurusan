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
  titlePanel(h1("Dashboard K2JURUSAN", align = "center")),
  sidebarLayout(
    sidebarPanel(
      selectInput("tabel", "Pilih Tabel:", 
                  choices = c("Wilayah", "Universitas", "Prodi", "Jalur_Masuk")),
      actionButton("loadData", "Muat Data", class = "btn-primary")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Tabel Data", DTOutput("dataTable")),
        tabPanel("Visualisasi", plotOutput("plot", height = "500px"))
      )
    )
  )
)

# Server Dashboard
server <- function(input, output) {
  
  con <- dbConnect(MySQL(), dbname = "K2JURUSAN", host = "127.0.0.1", 
                   port = 3306, user = "root", password = "")
  
  data_reactive <- eventReactive(input$loadData, {
    query <- sprintf("SELECT * FROM %s;", input$tabel)
    df <- dbGetQuery(con, query)
    if("akred_univ" %in% colnames(df)) {
      df$akred_univ <- factor(df$akred_univ, levels = c("U", "A", "B", "C"))
    }
    if("akred_prodi" %in% colnames(df)) {
      df$akred_prodi <- factor(df$akred_prodi, levels = c("U", "A", "B", "C"))
    }
    return(df)
  })
  
  output$dataTable <- renderDT({
    datatable(data_reactive(), options = list(pageLength = 10, autoWidth = TRUE))
  })
  
  output$plot <- renderPlot({
    df <- data_reactive()
    
    if (input$tabel == "Universitas") {
      ggplot(df, aes(x = akred_univ)) +
        geom_bar(fill = "#3498db", color = "black") +
        theme_minimal() +
        labs(title = "Distribusi Akreditasi Universitas", x = "Akreditasi", y = "Jumlah") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16))
    } else if (input$tabel == "Prodi") {
      ggplot(df, aes(x = akred_prodi, fill = akred_prodi)) +
        geom_bar(color = "black") +
        scale_fill_manual(values = c("#e74c3c", "#f39c12", "#2ecc71", "#3498db")) +
        theme_minimal() +
        labs(title = "Distribusi Akreditasi Prodi", x = "Akreditasi", y = "Jumlah") +
        theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16))
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
