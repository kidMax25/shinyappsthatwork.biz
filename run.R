library(shiny)

options(shiny.autoreload = TRUE)

ui <- htmlTemplate(
  "app/index.html",
  home = uiOutput("home"),
  gallery = uiOutput("gallery")
)

source("R/server.R")

shinyApp(ui = ui, server = server)
