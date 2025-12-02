library(shiny)
library(httr)
library(jsonlite)

#' Send Email via Resend API
send_email_resend <- function(to, subject, html, from, reply_to = NULL) {
  api_key <- Sys.getenv("RESEND_API_KEY")
  
  if (api_key == "") {
    stop("RESEND_API_KEY environment variable not set")
  }
  
  payload <- list(
    from = from,
    to = to,
    subject = subject,
    html = html
  )
  
  if (!is.null(reply_to)) {
    payload$reply_to <- reply_to
  }
  
  response <- POST(
    url = "https://api.resend.com/emails",
    add_headers(
      Authorization = paste("Bearer", api_key),
      `Content-Type` = "application/json"
    ),
    body = toJSON(payload, auto_unbox = TRUE),
    encode = "json"
  )
  
  return(response)
}

#' Format Contact Email
format_contact_email <- function(name, email, message, newsletter) {
  newsletter_status <- if (newsletter) {
    '<p style="color: #10b981; font-weight: bold;">✓ Subscribed to newsletter</p>'
  } else {
    '<p style="color: #6b7280;">Did not subscribe to newsletter</p>'
  }
  
  html <- sprintf('
    <!DOCTYPE html>
    <html>
    <body style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;">
      <div style="background: linear-gradient(135deg, #3b82f6 0%%, #1e40af 100%%); padding: 30px; border-radius: 10px 10px 0 0;">
        <h1 style="color: white; margin: 0;">New Contact Form Submission</h1>
      </div>
      
      <div style="background: #f9fafb; padding: 30px; border-radius: 0 0 10px 10px;">
        <div style="background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
          <h2 style="margin-top: 0; color: #1e293b;">Contact Information</h2>
          <p><strong>Name:</strong> %s</p>
          <p><strong>Email:</strong> <a href="mailto:%s">%s</a></p>
        </div>
        
        <div style="background: white; padding: 20px; border-radius: 8px; margin-bottom: 20px;">
          <h2 style="margin-top: 0; color: #1e293b;">Message</h2>
          <div style="background: #f9fafb; padding: 15px; border-radius: 6px; white-space: pre-wrap;">%s</div>
        </div>
        
        <div style="background: white; padding: 20px; border-radius: 8px;">
          <h2 style="margin-top: 0;">Newsletter</h2>
          %s
        </div>
      </div>
    </body>
    </html>
  ',
                  name, email, email, message, newsletter_status
  )
  
  return(html)
}

#' Store Newsletter Subscriber
store_newsletter_subscriber <- function(email, name = "", csv_path = "data/newsletter_subscribers.csv") {
  tryCatch({
    if (!dir.exists(dirname(csv_path))) {
      dir.create(dirname(csv_path), recursive = TRUE)
    }
    
    new_subscriber <- data.frame(
      email = email,
      name = name,
      subscribed_at = Sys.time(),
      source = "contact_form",
      stringsAsFactors = FALSE
    )
    
    if (file.exists(csv_path)) {
      existing <- read.csv(csv_path, stringsAsFactors = FALSE)
      if (email %in% existing$email) {
        return(TRUE)
      }
      updated <- rbind(existing, new_subscriber)
    } else {
      updated <- new_subscriber
    }
    
    write.csv(updated, csv_path, row.names = FALSE)
    return(TRUE)
    
  }, error = function(e) {
    warning("Failed to store newsletter subscriber: ", e$message)
    return(FALSE)
  })
}

#' Setup Contact Form Handler (for existing HTML form)
#' Call this in your server function
#' 
#' @param input Shiny input object
#' @param output Shiny output object  
#' @param session Shiny session object
#' @param recipient_email Your email address
#' @param from_email From address (must be verified in Resend)
#' 
#' @export
setup_contact_form <- function(input, output, session, 
                               recipient_email = "you@yourdomain.com",
                               from_email = "contact@yourdomain.com") {
  
  # Observe the submit button click from HTML form
  observeEvent(input$contact_submit, {
    
    # Get values from HTML inputs
    name <- input$contact_name
    email <- input$contact_email
    message <- input$contact_message
    newsletter <- input$contact_newsletter
    
    # Validate
    if (is.null(email) || email == "" || !grepl("@", email)) {
      showNotification(
        "Please enter a valid email address",
        type = "error",
        duration = 5
      )
      return()
    }
    
    if (is.null(message) || message == "") {
      showNotification(
        "Please enter a message",
        type = "warning",
        duration = 5
      )
      return()
    }
    
    # Show loading
    showNotification(
      "Sending message...",
      id = "sending",
      duration = NULL,
      type = "message"
    )
    
    # Format and send email
    tryCatch({
      email_html <- format_contact_email(
        name = ifelse(is.null(name) || name == "", "Not provided", name),
        email = email,
        message = message,
        newsletter = isTRUE(newsletter)
      )
      
      response <- send_email_resend(
        to = recipient_email,
        subject = sprintf("New Contact Form Submission from %s", 
                          ifelse(is.null(name) || name == "", email, name)),
        html = email_html,
        from = from_email,
        reply_to = email
      )
      
      if (status_code(response) %in% c(200, 201)) {
        
        # Store newsletter subscriber
        if (isTRUE(newsletter)) {
          store_newsletter_subscriber(email = email, name = name)
        }
        
        removeNotification("sending")
        
        showNotification(
          "Thank you for your message! We'll get back to you soon.",
          type = "message",
          duration = 5
        )
        
        # Clear form via JavaScript
        session$sendCustomMessage("clearContactForm", list())
        
      } else {
        removeNotification("sending")
        showNotification(
          "Failed to send message. Please try again later.",
          type = "error",
          duration = 5
        )
      }
      
    }, error = function(e) {
      removeNotification("sending")
      warning("Error sending email: ", e$message)
      showNotification(
        "An error occurred. Please try again later.",
        type = "error",
        duration = 5
      )
    })
  })
}