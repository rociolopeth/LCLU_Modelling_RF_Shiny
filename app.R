#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#


#------------load data---------------
y17 <- readRDS("data_shiny/y17.rds")
pred17 <- readRDS("data_shiny/pred17.rds")
y24 <- readRDS("data_shiny/y24.rds")
pred24 <- readRDS("data_shiny/pred24.rds")



library(shiny)
library(terra) 
library(tidyterra)
library(ggplot2)    
library(ggspatial)
library(dplyr)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("LCLU Santarem"),

    sidebarLayout(
        sidebarPanel(
            selectInput("year", "Year", choices = c("2017", "2024")),
            radioButtons("vis_type", "Visualization:", choices = c("RGB","Predicción"))
  
        ),

        mainPanel(
          plotOutput("plot_raster", click = "map_click"),
          plotOutput("spectrum_plot")
    
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  # Paleta Okabe-Ito
  okabe <- c("#D55E00", "#009E73", "#F5C710", "#56B4E9", "#0072B2", "#E69F00", "#CC79A7")
  
  output$plot_raster <- renderPlot({
    
    # Select input raster
    raster_to_plot <- switch(input$year,
                             "2017" = if(input$vis_type=="RGB") y17 else pred17,
                             "2024" = if(input$vis_type=="RGB") y24 else pred24)
    
    if(input$vis_type == "RGB"){
      # RGB: multiband
      ggplot() +
        geom_spatraster_rgb(data = raster_to_plot, stretch='hist') +
        ggtitle(paste(input$year, input$vis_type)) +
        theme_void()
    } else {
      # Prediction: cathegoric monolayer Okabe-Ito
      ggplot() +
        geom_spatraster(data = raster_to_plot) +
        scale_fill_manual(
          values = c(
            "barren" = okabe[1],
            "forest" = okabe[2],
            "veg"    = okabe[3],
            "water"  = okabe[5]
          ),
          na.value = "transparent",
          name = "Clase"
        ) +
        ggtitle(paste(input$year, input$vis_type)) +
        theme_void()
    }
    
    
  })
  
  output$spectrum_plot <- renderPlot({
    
    req(input$map_click)
    
    coords <- data.frame(
      x = input$map_click$x,
      y = input$map_click$y
    )
    
    # 🔹 Espectral Raster  (multiband)
    raster_for_spectrum <- switch(input$year,
                                  "2017" = y17,
                                  "2024" = y24)
    
    # 🔹 Prediction Raster
    raster_pred <- switch(input$year,
                          "2017" = pred17,
                          "2024" = pred24)
    
    # 🔹 Extract espectrum
    vals <- terra::extract(raster_for_spectrum, coords)
    vals <- vals[,-1]
    
    df <- data.frame(
      band = names(vals),
      value = as.numeric(vals[1,])
    )
    
    # 🔹 Extract class 
    pred_val <- terra::extract(raster_pred, coords)
    pred_class <- as.character(pred_val[1,2])  # columna de clase
    
    # 🔹 Bands
    band_order <- c(
      "Coastal_Aerosol", "Blue", "Green",
      "Red", "Red_Edge1", "Red_Edge2", "Red_Edge3",
      "NIR_Broad", "NIR_Narrow",
      "SWIR1", "SWIR2", "Water_Vapor"
    )
    
    df <- df[match(band_order, df$band), ]
    df$band_num <- 1:nrow(df)
    # 🔹 Wavelenghts (nm)
    wavelengths <- c(
      443, 490, 560,
      665, 705, 740, 783,
      842, 865,
      1610, 2200, 945
    )
    
    df$wavelength <- wavelengths
    # 🔹Okabe-Ito 
    class_colors <- c(
      "barren" = "#D55E00",
      "forest" = "#009E73",
      "veg"    = "#F5C710",
      "water"  = "#56B4E9"
    )
    
    color_line <- class_colors[pred_class]
    
    # 🔹 Plot
    # bands
    band_levels <- c(443, 482, 561, 655, 865, 1610, 2200)
    band_desc <- c("C. Aerosol (B1)", "Blue(B2)", "Green(B3)", "Red(B4)", "NIR1(B5)", "SWIR1(B6)", "SWIR2(B7)")
    
    
    df$wavelength <- as.numeric(df$wavelength)
    
    ggplot(df, aes(x = wavelength, y = value)) +
      geom_line(aes(group=1), color = color_line, linewidth = 1) +
      geom_point(color = color_line, size = 2) +
      labs(
        title = paste("Spectral signature -", input$year, "| Class:", pred_class),
        x = "Wavelength (nm)",
        y = "Reflectance"
      ) +
      scale_y_continuous(limits = c(-0.1,1)) +  
      scale_x_log10(
        breaks = band_levels,
        labels = band_levels,
        sec.axis = sec_axis(
          ~ .,                    
          breaks = band_levels,    
          labels = band_desc,      
          name = "Band Description"
        )
      ) +
      theme_minimal() +
      theme(
        axis.text.x = element_text(angle = 0, vjust = 0.5),           
        axis.text.x.top = element_text(angle = 45, hjust = 0, color = "blue", size = 10)  
      )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
