{smcl}
{* *! version 1.0.0  29 July 2025}{...}
{cmd:help detectoutlier}
{hline}

{title:Title}

{phang}
{bf:detectoutlier} — Detect outliers in survey variables and export them to Excel

{hline}

{title:Syntax}

{p 8 15 2}
{cmd:detectoutlier} {it:varlist}
{cmd:,} {opt using("filename.xlsx")} {opt addvar(varlist)} {opt sd(#)} {opt avoid(numlist)} 

{hline}

{title:Description}

{pstd}
The {cmd:detectoutlier} command identifies outliers in a list of survey variables using a user-specified standard deviation threshold.
Outliers are defined as values outside the range: 

{p 12 15 2}
mean ± (sd × standard deviation)

{pstd}
You can also specify values to be treated as special missing values (e.g. -99, -98, etc.).
Detected outliers are exported to an Excel spreadsheet, along with optional metadata variables.

{hline}

{title:Options}
{phang}
{opt using("filename.xlsx")} 
specifies the Excel file to export outlier results. If the file exists, the command will add to it (new sheet rows).

{phang}
{opt addvar(varlist)} 
specifies additional variables to include in the output file (e.g., respondent ID, interview date, etc.).

{phang}
{opt sd(#)} 
sets the standard deviation threshold. Default is 3.

{phang}
{opt avoid(numlist)} 
lists numeric codes to ignore when computing statistics (e.g., -96 -97 -98 -99 99). These values are treated as missing.



{hline}

{title:Example}

{phang2}
{cmd:. detectoutlier s3_q7_1 s3_q7_2 using "outliers.xlsx", addvar(fielddate enumerator) sd(2.5) avoid(-96 -97 -98 -99 99) }

{pstd}
Detects outliers more than 2.5 standard deviations from the mean for the specified survey variables,
ignores special codes, and exports flagged records to "outliers.xlsx".

{hline}

{title:Author}

{pstd}
This command was developed for internal data quality checks on survey datasets.

{pstd}
Contact: {it:Md. Redoan Hossain Bhuiyan} — redoanhossain630@gmail.com

{hline}

{title:Also see}

{psee}
Manual: {optcounts summarize D}, {manhelp export D}

{psee}
Other: {help su}, {help export excel}, {help program}

{hline}
