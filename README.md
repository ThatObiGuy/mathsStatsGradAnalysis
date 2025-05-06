# Gender Pay Gap Analysis in STEM Graduates

## Project Overview
This repository contains a data analysis project examining the gender pay divide among Level 8 graduates in Natural Sciences, Mathematics, and Statistics in Ireland. The analysis focuses on salary growth over the course of graduates' careers, with particular attention to disparities at key career stages.

## Context
This project was completed as a group assignment for the ST302 Data Visualization module. Our team analyzed Central Statistics Office (Ireland) data to uncover patterns in earnings between male and female graduates, using various data visualization techniques learned throughout the course.

## Key Questions Explored
1. Analysis of gender pay gap among newly-graduated mathematics/statistics students across different percentiles
2. Tracking graduate earnings progression over time by gender
3. Examining comparative growth rates of earnings between genders across all pay levels
4. Spotlight on gender pay gap later in graduates' careers (5-10 years post-graduation)

## Packages Used
The analysis utilizes several R packages:
- `tidyverse` - For data manipulation and visualization
- `plotly` - For creating interactive plots
- `ggiraph` - For interactive graphics
- `paletteer` - For accessing color palettes

## Contributors
- Owen O'Connor
- David Skerritt
- Warren Langridge
- Oisin Heaney

## Visualization Approach
We applied consistent visualization principles across our analyses:
- Colorblind-friendly palettes from ColorBrewer's 'paired' palette
- Intuitive color coding (blue/pink) to differentiate between genders
- Minimal themes to reduce visual noise and focus attention on key insights

## Key Findings
Our analysis reveals a pronounced pay gap between male and female graduates across all percentiles:
- The gap is evident immediately after graduation, particularly at higher income levels
- Males not only earn more than female counterparts but their earnings increase faster over time
- The gender pay gap widens in later career stages (5-10 years post-graduation)
- While earnings increase substantially over a 10-year period for both genders, male graduates experience greater financial growth

## File Structure
- `compiledAnalysis.Rmd` - R Markdown file containing all code and analysis
- `gradMS.Rdata` - Original dataset (Central Statistics Office data)

## How to Run
1. Clone this repository
2. Ensure you have R and the required packages installed
3. Open the `compiledAnalysis.Rmd` file in RStudio
4. Run the code chunks sequentially to reproduce the analysis
