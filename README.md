# 📊 detectoutlier: Outlier Detection and Export to Excel
`detectoutlier` is a Stata command that identifies outliers in numeric variables using the standard deviation method and exports the results to an Excel file. Outliers are defined as values that lie beyond a specified number of standard deviations from the mean. The command allows users to include additional variables (e.g., identifiers or metadata) in the output and saves the results in a structured Excel file.

## 🚀 Installation
You can install the command directly from GitHub:
```stata
net install detectoutlier, from("https://raw.githubusercontent.com/RanaRedoan/detectoutlier/main") replace
```
## 📖 Syntax
```stata
detectoutlier [varlist] [if] [in] using filename.xlsx, [addvars(varlist) sd(#) avoid(numlist)]
```

## 📌 Options
`using "filename.xlsx "` → Specifies the Excel file path for output (required).
`addvars(varlist)` → Additional variables to include in the output (e.g., ID variables).
`sd(#)` → Number of standard deviations to define outliers (default = 3).
`avoid(numlist)` → Values to exclude from analysis (e.g., -999 for missing data).

If no variables are specified, all numeric variables in the dataset are checked automatically.

## 📊 Description
detectoutlier identifies outliers based on the formula:
Outlier = Mean ± k * SD

The command exports an Excel file with a sheet named "Outlier" containing:
`variable` → Variable name
`label` → Variable label (if defined)
`value` → Outlier value
`min` → Minimum non-outlier value
`max` → Maximum non-outlier value
Additional columns → Included if specified in `addvars()`

After execution, Stata displays a completion message summarizing:
- Variables processed
- Variables with outliers detected
- Outlier definition used
- Values avoided

## 💻 Examples
Basic usage (check all numeric variables):
```stata
detectoutlier using "outliers.xlsx"
```
Specify variables and adjust SD threshold:
```stata
detectoutlier price mpg weight using "car_outliers.xlsx", sd(2.5)
```
Exclude specific values and include ID variables:
```stata
detectoutlier income expenditure using "output.xlsx", addvars(data_collector key hhid) sd(2.5) avoid(-999 -888)
```

### Example workflow in a .do file:
```stata
* Load dataset
use "survey_data.dta", clear

* Detect outliers and export to Excel
detectoutlier income expenditure, using("outliers.xlsx") addvars(key) sd(3) avoid(-999)
```
## 📊 Sample Output
The Excel sheet "Outlier" will contain columns like:
```text
| variable    | label         | value | min | max  | key | data\_collector |
| ----------- | ------------- | ----- | --- | ---- | --- | --------------- |
| income      | Income in USD | 10000 | 500 | 9000 | 101 | John            |
| expenditure | Monthly exp.  | 5000  | 100 | 4500 | 102 | Alice           |
```

##🧾 Completion Message
After execution, Stata displays:
```stata
-------------------------------------------------------------------------------
          OUTLIER DETECTION COMPLETED SUCCESSFULLY
-------------------------------------------------------------------------------
              Results saved to: C:\results.xlsx
              Variables processed: 15
       Variables with outliers found: 7
            Outlier definition: Mean ± 3 SD
                 Values avoided: -999 -888
-------------------------------------------------------------------------------
```
## 🤝 Contribution
Pull requests and suggestions are welcome!
If you find issues or have feature requests, please open an Issue in the repository.

##👨‍💻 Author
Md. Redoan Hossain Bhuiyan
📧 redoanhossain630@gmail.com

📌 License

This project is licensed under the MIT License.
