source("dependencies.R")
library(shiny)
library(shinydashboard)

# Define UI for the application
ui <- dashboardPage(
  dashboardHeader(title = "Nifty 50 Stock Data"),
  dashboardSidebar(
    selectInput(
      "company",
      "Select Company:",
      choices = c(
        "ADANIENT.NS", "APOLLOHOSP.NS", "ASIANPAINT.NS", "AXISBANK.NS",
        "BAJAJ-AUTO.NS", "BAJFINANCE.NS", "BAJAJFINSV.NS", "BPCL.NS",
        "BHARTIARTL.NS", "BEL.NS", "BRITANNIA.NS", "CIPLA.NS",
        "COALINDIA.NS", "DRREDDY.NS", "EICHERMOT.NS", "GRASIM.NS",
        "HCLTECH.NS", "HDFCBANK.NS", "HEROMOTOCO.NS", "HINDUNILVR.NS",
        "HINDALCO.NS", "ICICIBANK.NS", "INDUSINDBK.NS", "INFY.NS",
        "ITC.NS", "JSWSTEEL.NS", "KOTAKBANK.NS", "LT.NS",
        "M&M.NS", "MARUTI.NS", "ADANIPORTS.NS", "NTPC.NS",
        "ONGC.NS", "POWERGRID.NS", "RELIANCE.NS", "SBIN.NS",
        "SHRIRAMFIN.NS", "SUNPHARMA.NS", "TCS.NS", "TATACONSUM.NS",
        "TATAMOTORS.NS", "TATASTEEL.NS", "TECHM.NS", "TITAN.NS",
        "TRENT.NS", "ULTRACEMCO.NS", "WIPRO.NS", "NESTLEIND.NS",
        "SBILIFE.NS", "HDFCLIFE.NS"
      )
    ),
    dateRangeInput(
      "date_range",
      "Select Date Range:",
      start = Sys.Date() - 365,
      end = Sys.Date()
    ),
    actionButton("fetch_data", "Fetch Data")
  ),
  dashboardBody(
    tabBox(
      width = 12,
      tabPanel(
        "Stock Data Table",
        DTOutput("stock_table")
      ),
      tabPanel(
        "Performance Comparison",
        plotlyOutput("performance_plot")
      ),
      tabPanel(
        "Stock vs Nifty",
        plotlyOutput("stock_vs_nifty_plot")
      )
    )
  )
)
