
### 4. `example.do`
Detailed example file for the updated `optcounts`.

```stata
* Example script for optcounts
* Date: July 04, 2025
* Author: Md. Redoan Hossain Bhuiyan

* Clear existing data and set more off for better display
clear all
set more off

* Load the sample dataset
use "E:\Old Files[1] Project Task\[18] BRAC_BYP\[4] HFC\[3] 18032024\Final BYP surveydata.dta", clear

* Display dataset information
describe
summarize

* Run the optcounts command with example special values
di _n "Running optcounts with special values -99, 99, -999, -98, -96, 96:"
optcounts -99 99 -999 -98 -96 96, enum(a01)

* Explanation:
* - `-99 99 -999 -98 -96 96` are the special values to count across all variables.
* - `a01` is the enumerator variable.
* - The output shows the total count of these values and the number of surveys per enumerator.

* Optional: Verify the results with tabulate for a specific variable
di _n "Verifying with tabulate for a sample variable (e.g., d4):"
tabulate d4, nolabel

* Clean up (not necessary here as optcounts handles it)
* Note: optcounts automatically drops temporary variables

* Save the log of this session (optional)
log close