# LCLU_Modelling_RF_Shiny

## Description
This repository contains a hands-on training project based on the NASA course example for Land Cover and Land Use (LCLU) classification in the Santarém region, Brazil. The goal was to quickly produce trained datasets for use in interactive Shiny apps.

The project workflow is:

1. **LCLU Classification Notebook** (`LCLU_Classification_NASA_RF.Rmd`):  
   - Loads multiband HLS imagery for 2017 and 2024 (original data from NASA ARSET, **not included**).  
   - Uses prepared training points to train a Random Forest model on 2017 data.  
   - Applies the trained model to 2017 and 2024 imagery for classification.  
   - Saves **preprocessed rasters** that are included in this repository for use in the Shiny app.  

2. **Shiny App** (`app.R`):  
   - Interactive visualization of LCLU maps, predicted classes, temporal changes, and spectral reflectances.  
   - Uses the preprocessed datasets from the classification notebook for efficient exploration.

## Included Data
- `y17.rds` – 2017 raster used for the Shiny app  
- `y24.rds` – 2024 raster used for the Shiny app  
- `pred17.rds` – Predicted LCLU classes for 2017  
- `pred24.rds` – Predicted LCLU classes for 2024  

> **Note:** Original NASA HLS multiband imagery and training points are **not included**. They can be obtained from the [NASA ARSET LCLUC GitHub repository](https://github.com/NASAARSET/LCLUC_2026).

## How to Use
1. **Random Forest Classification**  
   - Open `LCLU_Classification_NASA_RF.Rmd` in RStudio to review the workflow. Original NASA imagery is not included.  

2. **Shiny App**  
   - Open `app.R` in RStudio and click **Run App**.  
   - Explore interactive maps, view predicted LCLU classes, temporal changes, and reflectance values for each band.

## References
- NASA course: [ARSET - Visualizing Land Cover and Land Use Change with NASA Satellite Imagery](https://www.earthdata.nasa.gov/learn/trainings/visualizing-land-cover-land-use-change-nasa-satellite-imagery)  
- Example datasets: [NASA ARSET LCLUC GitHub repository](https://github.com/NASAARSET/LCLUC_2026)  

## Skills Demonstrated
- R programming for spatial data (`terra`, `tidyterra`)  
- Machine learning with Random Forest (`randomForest`)  
- Interactive visualization using Shiny  
- Handling multiband satellite imagery and reproducible workflows
