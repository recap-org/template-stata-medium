/* ==============================================================================
   Analysis
   
   This script:
   - Cleans raw data into processed data
   - Saves processed data
============================================================================== */

// Setup
clear all
set more off

// Load raw data
import delimited "data/raw/data.csv", clear

// Data transformation: convert percentages to proportions
replace attendance_percent = attendance_percent / 100
replace previous_scores = previous_scores / 100
replace exam_score = exam_score / 100

// Display summary statistics
summarize, detail


// Save processed data
export delimited "data/processed/data.csv", replace

// Display confirmation message
display "Data cleaning complete. Processed data saved to data/processed/data.csv"
