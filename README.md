# LCLU_Modelling_RF_Shiny

## Description
This repository contains a hands-on training project based on the NASA course example for Land Cover and Land Use (LCLU) classification in the Santarém region, Brazil. The goal was to quickly produce trained datasets to focus on developing interactive Shiny apps.

The project workflow is:

1. **LCLU Classification Notebook** (`LCLU_classification_nasa.Rmd`):  
   - Loads multiband HLS imagery for 2017 and 2024.  
   - Uses prepared training points to train a Random Forest model on 2017 data.  
   - Applies the trained model to 2017 and 2024 imagery for classification.  
   - Crops and saves processed rasters for use in the Shiny app.  

2. **Shiny App** (`app.R`):  
   - Interactive visualization of LCLU maps, predicted classes, temporal changes, and spectral reflectances.  
   - Uses preprocessed data from the classification notebook for efficient exploration.


## How to Use
1. **Random Forest Classification**  
   - Open `LCLU_classification_nasa.Rmd` in RStudio and run each chunk to reproduce the training and prediction workflow.  

2. **Shiny App**  
   - Open `app.R` in RStudio and click **Run App**.  
   - Explore interactive maps, view predicted LCLU classes, temporal changes, and reflectance values for each band.

## References
- NASA course: [(2026). ARSET - Visualizing Land Cover and Land Use Change with NASA Satellite Imagery. [https://www.earthdata.nasa.gov/learn/trainings/visualizing-land-cover-land-use-change-nasa-satellite-imagery]
  
- Example datasets: [[Link to NASA GitHub repository](https://github.com/NASAARSET/LCLUC_2026)]  

## Skills Demonstrated
- R programming for spatial data (`terra`, `tidyterra`)  
- Machine learning with Random Forest (`randomForest`)  
- Interactive visualization using Shiny  
- Handling multiband satellite imagery and reproducible workflows
