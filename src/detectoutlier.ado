
*! version 1.0.9 30Jul2025
program define detectoutlier
    version 16
    syntax varlist [if] [in] using/, [ADDvars(string) SD(real 3) AVOID(string)]

    * Mark the sample
    marksample touse, novarlist
    qui count if `touse'
    di "Total observations in analysis: " r(N)

    preserve
    qui keep if `touse'

    * Initialize Excel header sheet
    loc row = 2                             // Data starts at row 2
    loc headeropt = "firstrow(variables)"  // Header written only once
    loc sheetmode = "sheetreplace"         // First write replaces sheet

    * Create header template
    clear
    set obs 1
    if "`addvars'" != "" {
        foreach addvar in `addvars' {
            gen `addvar' = ""
        }
    }
    gen variable = ""
    gen label = ""
    gen value = .
    gen min = .
    gen max = .

    export excel using "`using'", sheet("Outlier") `headeropt' cell("A1") `sheetmode'

    restore
    preserve
    qui keep if `touse'

    * Loop through each variable
    foreach var in `varlist' {
        cap confirm variable `var'
        if _rc {
            di as text "Variable `var' not found - skipped"
            continue
        }

        * Check for valid data
        qui count if !missing(`var')
        if r(N) == 0 {
            di as text "Variable `var' has no observations - skipped"
            continue
        }

        * Apply avoid values if specified
        if "`avoid'" != "" {
            foreach num in `avoid' {
                qui replace `var' = . if `var' == `num'
            }
            qui count if !missing(`var')
            if r(N) == 0 {
                di as text "Variable `var' became empty after avoid - skipped"
                continue
            }
        }

        * Compute statistics
        qui sum `var', detail
        loc mean = r(mean)
        loc sd_val = r(sd)
        loc min_val = r(min)
        loc max_val = r(max)

        * Flag outliers
        gen outlier = 0
        replace outlier = 1 if ((`var' > (`mean' + `sd'*`sd_val')) | ///
                             (`var' < (`mean' - `sd'*`sd_val'))) & !missing(`var')

        * Add columns
        gen variable = "`var'"
        loc labeltext : var label `var'
        gen label = "`labeltext'"
        gen value = `var'
        gen min = `min_val'
        gen max = `max_val'

        * Keep only outliers
        keep if outlier == 1
        if _N > 0 {
            if "`addvars'" != "" {
                export excel `addvars' variable label value min max using "`using'" ///
                    , sheet("Outlier") `sheetmode' `headeropt' cell("A`row'")
            }
            else {
                export excel variable label value min max using "`using'" ///
                    , sheet("Outlier") `sheetmode' `headeropt' cell("A`row'")
            }

            * Update row for next export
            qui count
            loc row = `row' + r(N)

            * Disable headers and switch to append mode after first write
            loc headeropt = ""
            loc sheetmode = "sheetmodify"
        }

        restore
        preserve
        qui keep if `touse'
    }

    restore
end

