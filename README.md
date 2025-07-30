# detectoutlier - Stata Command for Outlier Detection

## Overview
`detectoutlier` is a Stata command that identifies outliers in numeric variables using the standard deviation method and exports the results to an Excel file. Outliers are defined as values that lie beyond a specified number of standard deviations from the mean. The command allows users to include additional variables (e.g., identifiers or metadata) in the output and saves the results in a structured Excel file.

## Features
- Detects outliers in one or more numeric variables.
- Supports customizable standard deviation threshold (default: 3).
- Allows inclusion of additional variables (e.g., ID, enumerator name, date) in the output.
- Exports results to an Excel file (.xlsx) with columns for variable name, variable label, additional variables, and outlier values.
- Preserves the original dataset.

## Installation
To install `detectoutlier` from this GitHub repository, use the following command in Stata:

```stata
net install detectoutlier, from("https://raw.githubusercontent.com/ranaredoan/detectoutlier/main/")

## Command Syntax
```stata
detectoutlier [varlist] [if] [in] using filename.xlsx, [ADDvars(varlist) SD(#) AVOID(numlist)]
