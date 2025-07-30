*============================================================*
*                    DETECTOUTILER EXAMPLE DO FILE           *
*                    Last updated: 30Jul2025                 *
*============================================================*

* This do file demonstrates the usage of detectoutlier command *
* with different scenarios and detailed explanations          *

clear all
set more off

*------------------------------------------------------------*
* SECTION 1: SETUP AND SAMPLE DATA CREATION
*------------------------------------------------------------*

// Create a sample dataset with numeric variables and some outliers
set obs 100
set seed 1234

// Generate normal variables with some outliers
gen income = rnormal(50000, 15000)  // Normal distribution
replace income = 250000 in 1/3      // Add some outliers (high income)
replace income = 5000 in 98/100     // Add some outliers (low income)

gen age = rnormal(45, 15)           // Normal distribution
replace age = 150 in 5              // Impossible age outlier
replace age = -10 in 95             // Negative age outlier

// Generate ID variable
gen id = _n

// Add variable labels
label variable income "Annual household income (USD)"
label variable age "Respondent age (years)"
label variable id "Household ID"

// Create some special missing values (-999)
replace income = -999 in 10/12      // Add missing value codes


*------------------------------------------------------------*
* SECTION 2: BASIC USAGE - DETECT OUTLIERS IN ALL NUMERIC VARS
*------------------------------------------------------------*

/*
Basic syntax when no variables are specified:
- Checks all numeric variables in dataset
- Uses default 3 SD threshold
- Exports to basic_outliers.xlsx
*/

detectoutlier using "basic_outliers.xlsx"


*------------------------------------------------------------*
* SECTION 3: SPECIFIC VARIABLES WITH CUSTOM SD THRESHOLD
*------------------------------------------------------------*

/*
This example:
- Only checks 'income' and 'age' variables
- Uses 2.5 SD threshold instead of default 3
- Exports to custom_sd_outliers.xlsx
*/

detectoutlier income age using "custom_sd_outliers.xlsx", sd(2.5)


*------------------------------------------------------------*
* SECTION 4: WITH AVOID VALUES AND ADDITIONAL VARIABLES
*------------------------------------------------------------*

/*
This example demonstrates:
- Specifying values to exclude (-999)
- Including an ID variable in output
- Using default 3 SD threshold
- Exports to full_featured_outliers.xlsx
*/

detectoutlier income age using "full_featured_outliers.xlsx", ///
    avoid(-999) addvars(id)


*------------------------------------------------------------*
* SECTION 5: REAL-WORLD EXAMPLE WITH AUTO DATASET
*------------------------------------------------------------*

// Load Stata's built-in auto dataset
sysuse auto, clear

/*
This example shows:
- Practical application with real data
- Checking price and mpg variables
- Adding make (car name) to output
- Excluding missing codes (.)
- Using 2 SD threshold
*/

detectoutlier price mpg using "auto_outliers.xlsx", ///
    sd(2) avoid(.) addvars(make)



*------------------------------------------------------------*
* END OF DO FILE
*------------------------------------------------------------*
