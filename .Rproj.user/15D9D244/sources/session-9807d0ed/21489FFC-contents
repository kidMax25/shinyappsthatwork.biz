library(shiny)


server <- function(input, output, session) {
  
  # Render Home Page Content
  output$home <- renderUI({
    print("Rendering home page")
    includeHTML("app/home.html")
  })
  
  # Render Gallery Page Content
  output$gallery <- renderUI({
    if (!file.exists("app/gallery.html")) {
      print("ERROR: app/gallery.html not found!")
      return(tags$div(
        class = "min-h-screen flex items-center justify-center",
        tags$h2("Gallery file not found")
      ))
    }
    
    print("Gallery file found, loading...")
    includeHTML("app/gallery.html")
  })
  
  # Handle contact form submission
  observeEvent(input$submit_contact, {
    showNotification(
      "Thank you for your message! We'll get back to you soon.",
      type = "message",
      duration = 5
    )
  })
}