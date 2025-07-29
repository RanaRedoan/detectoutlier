{smcl}
{* *! version 1.0.0  29jul2025}{...}
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
{cmd:detectoutlier} {varlist} [{cmd:,} {opt addvar(varlist)} {opt sd(real)} {opt using(filename)}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{synopt:{opt addvar(varlist)}}Additional variables to include in the output{p_end}
{synopt:{opt sd(real)}}Number of standard deviations to define outliers; default is {cmd:sd(3)}{p_end}
{synopt:{opt using(filename)}}Excel file to save the results; must have .xlsx extension{p_end}
{synoptline}
{p2colreset}{...}

{pstd}
{varlist} must contain numeric variables only.

{marker description}{...}
{title:Description}

{pstd}
{cmd:detectoutlier} identifies outliers in the specified numeric variables using the standard deviation method. An observation is considered an outlier if its value lies beyond the mean plus or minus a specified number of standard deviations. The results are exported to an Excel file, including the variable name, variable label, specified additional variables, and the outlier value.

{marker options}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt addvar(varlist)} specifies additional variables to include in the output Excel file, such as identifiers or metadata (e.g., id, enumerator_name, date).

{phang}
{opt sd(real)} specifies the number of standard deviations from the mean to use as the threshold for identifying outliers. The default is 3.

{phang}
{opt using(filename)} specifies the Excel file where the results will be saved. The filename must have a .xlsx extension. This option is required.

{marker examples}{...}
{title:Examples}

{pstd}Detect outliers in variables {cmd:price} and {cmd:weight}, including {cmd:id} and {cmd:date} in the output, using 3 standard deviations, and save to "outliers.xlsx":{p_end}

{phang2}{cmd:. detectoutlier price weight, addvar(id date) sd(3) using "outliers.xlsx"}{p_end}

{pstd}Detect outliers in variable {cmd:income} using 2.5 standard deviations, including {cmd:region} in the output:{p_end}

{phang2}{cmd:. detectoutlier income, addvar(region) sd(2.5) using "income_outliers.xlsx"}{p_end}

{marker results}{...}
{title:Stored results}

{pstd}
{cmd:detectoutlier} does not store any results in {cmd:r()} or {cmd:e()}.

{marker author}{...}
{title:Author}

{pstd}
[Your Name], [Your Institution/Organization]{p_end}
{pstd}
Email: [Your Email]{p_end}

{pstd}
To install this command from GitHub, use:{p_end}
{phang2}{cmd:. net install detectoutlier, from("https://raw.githubusercontent.com/yourusername/yourrepo/main/")}{p_end}

{pstd}
Please replace [Your Name], [Your Institution/Organization], [Your Email], and the GitHub URL with your actual details.

{smcl}
{* *! version 1.0.0  29jul2025}