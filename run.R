library(shiny)
library(dotenv)

load_dot_env()
cat("RESEND_API_KEY loaded", Sys.getenv("RESEND_API_KEY") != "", "\n")

options(shiny.autoreload = TRUE)

ui <- htmlTemplate(
  "app/index.html",
  home = uiOutput("home"),
  gallery = uiOutput("gallery")
)

source("R/server.R")

shinyApp(ui = ui, server = server)
