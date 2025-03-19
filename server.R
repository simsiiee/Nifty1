source("dependencies.R")
library(shiny)
library(quantmod)
library(DT)
library(plotly)

# Define server logic
server <- function(input, output) {
  stock_data <- eventReactive(input$fetch_data, {
    company_symbol <- input$company
    start_date <- input$date_range[1]
    end_date <- input$date_range[2]

    company_data <- tryCatch(
      {
        getSymbols(company_symbol,
                   from = start_date,
                   to = end_date,
                   auto.assign = FALSE)
      },
      error = function(e) {
        showNotification(paste("Error fetching data for", company_symbol, ":", e$message), type = "error")
        NULL
      }
    )

    nifty_data <- tryCatch(
      {
        getSymbols("^NSEI",
                   from = start_date,
                   to = end_date,
                   auto.assign = FALSE)
      },
      error = function(e) {
        showNotification(paste("Error fetching data for Nifty Index:", e$message), type = "error")
        NULL
      }
    )

    list(company = company_data, nifty = nifty_data)
  })

  output$stock_table <- renderDT({
    data <- stock_data()$company
    if (!is.null(data)) {
      datatable(data,
                options = list(order = list(1, 'desc')), # Order by date descending
                rownames = TRUE)
    } else {
      data.frame(Message = "No data available for the selected company and date range.")
    }
  })

  output$performance_plot <- renderPlotly({
    data_list <- stock_data()
    company_data <- data_list$company
    nifty_data <- data_list$nifty

    if (!is.null(company_data) && !is.null(nifty_data)) {
      # Extract adjusted closing prices
      company_prices <- Ad(company_data)
      nifty_prices <- Ad(nifty_data)

      # Calculate percentage change relative to the first day
      company_start_price <- as.numeric(company_prices[1])
      nifty_start_price <- as.numeric(nifty_prices[1])

      company_pct_change <- (company_prices / company_start_price - 1) * 100
      nifty_pct_change <- (nifty_prices / nifty_start_price - 1) * 100

      # Combine the data into a data frame for plotting
      plot_data <- data.frame(
        Date = index(company_prices),
        Company = as.numeric(company_pct_change),
        Nifty = as.numeric(nifty_pct_change)
      )
      names(plot_data)[2] <- input$company # Rename the company column

      # Create the plot using plotly
      p <- plot_ly(plot_data, x = ~Date, type = "scatter", mode = "lines") %>%
        add_trace(y = ~get(names(plot_data)[2]), name = input$company) %>%
        add_trace(y = ~Nifty, name = "Nifty 50") %>%
        layout(
          title = paste("Performance Comparison:", input$company, "vs. Nifty 50"),
          xaxis = list(title = "Date"),
          yaxis = list(title = "Percentage Change")
        )
      p
    } else {
      plotly_empty(type = "scatter", mode = "lines", message = "No data available for performance comparison.")
    }
  })

  output$stock_vs_nifty_plot <- renderPlotly({
    data_list <- stock_data()
    company_data <- data_list$company
    nifty_data <- data_list$nifty

    if (!is.null(company_data) && !is.null(nifty_data)) {
      # Extract adjusted closing prices
      company_prices <- Ad(company_data)
      nifty_prices <- Ad(nifty_data)

      # Create the plotly plot with secondary Y-axis
      p <- plot_ly(x = index(company_prices), type = "scatter", mode = "lines") %>%
        add_trace(y = as.numeric(company_prices), name = input$company, yaxis = "y2", line = list(color = "blue")) %>%
        add_trace(y = as.numeric(nifty_prices), name = "Nifty 50", yaxis = "y1", line = list(color = "green")) %>%
        layout(
          title = paste(input$company, "vs. Nifty 50 Price Movement"),
          xaxis = list(title = "Date"),
          yaxis = list(title = "Nifty 50 Price", side = "left"),
          yaxis2 = list(title = paste(input$company, "Price"), side = "right", overlaying = "y", position = 1),
          legend = list(orientation = 'h', yanchor = 'bottom', y = 1.02, xanchor = 'right', x = 1)
        )
      p
    } else {
      plotly_empty(type = "scatter", mode = "lines", message = "No data available for Stock vs Nifty comparison.")
    }
  })
}
