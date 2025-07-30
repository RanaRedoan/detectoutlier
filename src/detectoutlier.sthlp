*! version 1.2.0 30Jul2025
*! Outlier detection and export to Excel

{smcl}
{title:Title}

{p 4 4 2}
{bf:detectoutlier} - Detect outliers using standard deviation method and export to Excel


{title:Syntax}

{p 4 4 2}
{cmd:detectoutlier} [{varlist}] [{cmd:if}] [{cmd:in}] {cmd:using} {it:filename.xlsx}{cmd:,} [{cmdab:ADDvars(}{it:varlist}{cmd:)} {cmdab:SD(}{it:#}{cmd:)} {cmdab:AVOID(}{it:numlist}{cmd:)}]


{title:Description}

{p 4 4 2}
{cmd:detectoutlier} identifies outliers in numeric variables based on the mean ± k standard deviations (SD). The command exports results to an Excel file with variable names, labels, outlier values, and summary statistics. When no variables are specified, it automatically checks all numeric variables in the dataset.


{title:Options}

{dlgtab:Main}

{phang}
{opt using} specifies the Excel file path for output (required).

{phang}
{opt ADDvars(varlist)} specifies additional variables to include in the output (e.g., ID variables).

{phang}
{opt SD(#)} sets the number of standard deviations to define outliers (default is 3).

{phang}
{opt AVOID(numlist)} specifies values to exclude from analysis (e.g., -999 for missing data).


{title:Examples}

{p 4 4 2}
Basic usage (check all numeric variables):

{p 8 12 2}
{cmd:. detectoutlier using "outliers.xlsx"}

{p 4 4 2}
Specify variables and adjust SD threshold:

{p 8 12 2}
{cmd:. detectoutlier price mpg weight using "car_outliers.xlsx", SD(2.5)}

{p 4 4 2}
Exclude specific values and keep ID variable:

{p 8 12 2}
{cmd:. detectoutlier income expenditure using "output.xlsx", addvars(data_collector key hhid) sd(2.5) avoid(-999 -888)}


{title:Output Structure}

{p 4 4 2}
The Excel file contains a sheet named "Outlier" with these columns:

{p2colset 8 24 26 8}{...}
{p2col :{bf:variable}}Variable name{p_end}
{p2col :{bf:label}}Variable label (if defined){p_end}
{p2col :{bf:value}}Outlier value{p_end}
{p2col :{bf:min}}Minimum non-outlier value{p_end}
{p2col :{bf:max}}Maximum non-outlier value{p_end}
{p2col :*Additional columns}If specified in {cmd:ADDvars()}{p_end}


{title:Completion Message}

{p 4 4 2}
After execution, Stata displays a summary:

{cmd}
-------------------------------------------------------------------------------
          OUTLIER DETECTION COMPLETED SUCCESSFULLY
-------------------------------------------------------------------------------
              Results saved to: C:\results.xlsx
              Variables processed: 15
       Variables with outliers found: 7
            Outlier definition: Mean ± 3 SD
                 Values avoided: -999 -888
-------------------------------------------------------------------------------
{txt}

{title:Author}

{p 4 4 2}
Md. Redoan Hossain Bhuiyan

{p 4 4 2}
Email: redoanhossain630@gmail.com


{title:Version}

{p 4 4 2}
Version 1.2.0, 30 July 2025


{title:License}

{p 4 4 2}
MIT License
