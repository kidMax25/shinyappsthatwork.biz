library(shiny)

source("R/modules/contact.R")


server <- function(input, output, session) {
  
  
  output$home <- renderUI({
    print("Rendering home page")
    tagList(
      includeHTML("app/home.html"),
      
      
      tags$script(HTML("
      // Create Shiny input bindings manually
      $(document).ready(function() {
        // Text inputs
        Shiny.setInputValue('contact_name', '', {priority: 'event'});
        Shiny.setInputValue('contact_email', '', {priority: 'event'});
        Shiny.setInputValue('contact_message', '', {priority: 'event'});
        Shiny.setInputValue('contact_newsletter', false, {priority: 'event'});
        
        // Listen to changes
        $('#contact_name').on('input', function() {
          Shiny.setInputValue('contact_name', $(this).val());
        });
        
        $('#contact_email').on('input', function() {
          Shiny.setInputValue('contact_email', $(this).val());
        });
        
        $('#contact_message').on('input', function() {
          Shiny.setInputValue('contact_message', $(this).val());
        });
        
        $('#contact_newsletter').on('change', function() {
          Shiny.setInputValue('contact_newsletter', $(this).is(':checked'));
        });
        
        $('#contact_submit').on('click', function() {
          Shiny.setInputValue('contact_submit', Math.random(), {priority: 'event'});
        });
      });
    "))
            )
  })
  
  
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
  
  setup_contact_form(
    input = input,
    output = output,
    session = session,
    recipient_email = Sys.getenv("RECIPIENT_EMAIL"),
    from_email = Sys.getenv("FROM_EMAIL")
  )
  
  
  observeEvent(input$contact_submit, {
    cat("Name:", input$contact_name, "\n")
    cat("Email:", input$contact_email, "\n")
    cat("Message:", input$contact_message, "\n")
    cat("Newsletter:", input$contact_newsletter, "\n")
  })
}