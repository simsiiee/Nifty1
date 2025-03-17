# List of required packages
required_packages <- c("shiny", "shinydashboard", "quantmod", "DT", "plotly")

# Function to check if a package is installed
is_installed <- function(pkg){
  is.element(pkg, installed.packages()[,1])
}

# Install missing packages
for (pkg in required_packages) {
  if (!is_installed(pkg)){
    install.packages(pkg, repos = "https://cloud.r-project.org")
  }
}

# Optionally, load the libraries (though ui.R and server.R will also load them)
# library(shiny)
# library(shinydashboard)
# library(quantmod)
# library(DT)
# library(plotly)
