librarian::shelf(kableExtra,knitr,summarytools,fastDummies, plotly, patchwork,cowplot, bookdown, purrr, forcats, anytime, tidyverse,stringi, remotes, gdata , readxlsb, scales,stringr, stringdist,tidytext, lubridate,writexl,readxl,openxlsx,gt, gtsummary)

working_dir <- "C:/Users/T-ROEDERER/OneDrive - MSF/TR/Consult/RDC/Capitalisation 2020-2023"

# Set the working directory to the "Analysis" folder
setwd(working_dir)

monthas <- read_excel(paste0(working_dir, "/Shiny apps/monthas.xlsx"), col_names = TRUE, sheet = 1)


# Assuming your data frame is named vv2 and columns are named correctly
# monthly_cases_as, n, as_nom, zs_nom, and Province

# Define the user interface (UI)
ui <- fluidPage(
  titlePanel("Courbes Epi"),
  sidebarLayout(
    sidebarPanel(
      selectInput("provinceInput", "Choisir la Province:", choices = unique(monthas$Province)),
      uiOutput("zsNomSelect")  # This will be dynamically rendered based on the selected province
    ),
    mainPanel(
      plotlyOutput("dynamicPlot")
    )
  )
)

# Define the server function
server <- function(input, output) {
  # Render the submenu for zs_nom based on the selected province
  output$zsNomSelect <- renderUI({
    province <- input$provinceInput
    zs_noms <- unique(infosup$zs_nom[infosup$Province == province])
    selectInput("zsNomInput", "Choisir la Zone de Santé:", choices = zs_noms)
  })
  
  # Create dynamic plot based on the selected province and zs_nom
  output$dynamicPlot <- renderPlotly({
    province <- input$provinceInput
    zs_nom <- input$zsNomInput
    
    subset_data <- monthas[monthas$Province == province & monthas$zs_nom == zs_nom, ]
    
    plot_ly(subset_data,
            x = subset_data$monthly_cases_as,
            y = subset_data$n,
            group = subset_data$as_nom,
            color = subset_data$as_nom,
            alpha = 0.5) %>%
      add_lines() %>%
      layout(title = paste(province, zs_nom),
             xaxis = list(title = "Mois"),
             yaxis = list(title = "Nb de cas/Mois"))
  })
}

# Run the Shiny app
shinyApp(ui, server)
