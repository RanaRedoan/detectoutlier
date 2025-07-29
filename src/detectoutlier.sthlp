```stata
{smcl}
{* *! version 1.3.0  29jul2025}{...}
{viewerjumpto "Syntax" "detectoutlier##syntax"}{...}
{viewerjumpto "Description" "detectoutlier##description"}{...}
{viewerjumpto "Options" "detectoutlier##options"}{...}
{viewerjumpto "Examples" "detectoutlier##examples"}{...}
{viewerjumpto "Stored results" "detectoutlier##results"}{...}
{viewerjumpto "Author" "detectoutlier##author"}{...}

{title:Title}

{phang}
{bf:detectoutlier} {hline 2} Detect outliers in numeric variables and export results to Excel

{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:detectoutlier} {varlist} [{cmd:,} {opt addvar(varlist)} {opt sd(real)} {opt using(filename)} {opt avoid(numlist)}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt addvar(varlist)}}Additional variables to include in the output{p_end}
{synopt:{opt sd(real)}}Number of standard deviations to define outliers; default is {cmd:sd(3)}{p_end}
{synopt:{opt using(filename)}}Excel file to save the results; must have .xlsx extension{p_end}
{synopt:{opt avoid(numlist)}}List of values to exclude from outlier detection (set to missing){p_end}
{synoptline}
{p2colreset}{...}

{pstd}
{varlist} must contain numeric variables only.

{marker description}{...}
{title:Description}

{pstd}
{cmd:detectoutlier} identifies outliers in the specified numeric variables using the standard deviation method. An observation is considered an outlier if its value lies beyond the mean plus or minus a specified number of standard deviations. The results are exported to an Excel file in the "Outlier" sheet, including the variable name, variable label, specified additional variables, and the outlier value.

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt addvar(varlist)} specifies additional variables to include in the output Excel file, such as identifiers or metadata (e.g., key, supervisor, enumerator, date).

{phang}
{opt sd(real)} specifies the number of standard deviations from the mean to use as the threshold for identifying outliers. The default is 3.

{phang}
{opt using(filename)} specifies the Excel file where the results will be saved. The filename must have a .xlsx extension. This option is required.

{phang}
{opt avoid(numlist)} specifies a list of numeric values (e.g., -99 99 -97) to be excluded from outlier detection by setting them to missing.

{marker examples}{...}
{title:Examples}

{pstd}Detect outliers in variables {cmd:s3_1_5} and {cmd:s3ಸ3_1_6}, including {cmd:key} in the output, using 3 standard deviations, excluding -99 and 99, and save to "income_outliers.xlsx":{p_end}

{phang2}{cmd:. detectoutlier s3_1_5 s3_1_6, addvar(key) sd(3) using "income_outliers.xlsx" avoid(-99 99)}{p_end}

{pstd}Detect outliers in variables {cmd:s3_q7_1} to {cmd:s3_q7_4}, including {cmd:sup}, {cmd:enum}, {cmd:fielddate}, and {cmd:key}, excluding -96, -97, -98, -99, and 99, and save to "outliers.xlsx":{p_end}

{phang2}{cmd:. detectoutlier s3_q7_1 s3_q7_2 s3_q7_3 s3_q7_4, addvar(sup enum fielddate key) sd(2.5) using "outliers.xlsx" avoid(-96 -97 -98 -99 99)}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:detectoutlier} does not store any results in {cmd:r()} or {cmd:e()}.

{marker author}{...}
{title:Author}

{pstd}
[Md. Redoan Hossain Bhuiyan]{p_end}
{pstd}
Email: [redoanhossain630@gmail.com]{p_end}


{smcl}
{* *! version 1.3.0  29jul2025}
```
