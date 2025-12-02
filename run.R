library(shiny)
library(dotenv)

load_dot_env()
cat("RESEND_API_KEY loaded", Sys.getenv("RESEND_API_KEY") != "", "\n")

port <- as.numeric(Sys.getenv("PORT", "5000"))
host <- Sys.getenv("HOST", "0.0.0.0")

options(shiny.autoreload = TRUE, shiny.port = port, shiny.host = host)

ui <- htmlTemplate(
  "app/index.html",
  home = uiOutput("home"),
  gallery = uiOutput("gallery")
)

source("R/server.R")

shinyApp(ui = ui, server = server)
