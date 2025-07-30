*! version 1.0.10 30Jul2025
program define detectoutlier
    version 16
    syntax [varlist] [if] [in] using/, [ADDvars(string) SD(real 3) AVOID(string)]

    * Mark the sample
    marksample touse, novarlist
    qui count if `touse'
    di "Total observations in analysis: " r(N)

    * If no variables specified, use all numeric variables
    if "`varlist'" == "" {
        quietly ds, has(type numeric)
        local varlist `r(varlist)'
        di "No variables specified - checking all numeric variables: `varlist'"
    }

    preserve
    qui keep if `touse'

    * Initialize Excel header sheet
    loc row = 1                           // Data starts at row 1
    loc headeropt = "firstrow(variables)" // Header written only once
    loc sheetmode = "sheetreplace"        // First write replaces sheet

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

    * Initialize counter for variables processed
    local vars_processed 0
    local vars_with_outliers 0

    * Loop through each variable
    foreach var in `varlist' {
        cap confirm variable `var'
        if _rc {
            di as text "Variable `var' not found - skipped"
            continue
        }

        * Check if variable is numeric
        cap confirm numeric variable `var'
        if _rc {
            di as text "Variable `var' is not numeric - skipped"
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

        * Count variables processed
        local vars_processed = `vars_processed' + 1

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
            local vars_with_outliers = `vars_with_outliers' + 1
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

    * Display center-aligned completion message
    di as result _n(2)
    
    * Calculate padding for center alignment (assuming 78 character width)
    local width 78
    local border "{hline `width'}"
    
    * Center-align each line
    local title "OUTLIER DETECTION COMPLETED SUCCESSFULLY"
    local title_len = strlen("`title'")
    local title_pad = int((`width' - `title_len')/2)
    local centered_title "{dup `title_pad': }{bf:`title'}"
    
    local results_line "Results saved to: {ul:`using'}"
    local results_len = strlen("Results saved to: `using'")
    local results_pad = int((`width' - `results_len')/2)
    local centered_results "{dup `results_pad': }{bf:`results_line'}"
    
    local vars_line "Variables processed: `vars_processed'"
    local vars_len = strlen("`vars_line'")
    local vars_pad = int((`width' - `vars_len')/2)
    local centered_vars "{dup `vars_pad': }{bf:`vars_line'}"
    
    local outliers_line "Variables with outliers found: `vars_with_outliers'"
    local outliers_len = strlen("`outliers_line'")
    local outliers_pad = int((`width' - `outliers_len')/2)
    local centered_outliers "{dup `outliers_pad': }{bf:`outliers_line'}"
    
    local sd_line "Outlier definition: Mean ± `sd' SD"
    local sd_len = strlen("`sd_line'")
    local sd_pad = int((`width' - `sd_len')/2)
    local centered_sd "{dup `sd_pad': }{bf:`sd_line'}"
    
    if "`avoid'" != "" {
        local avoid_line "Values avoided: `avoid'"
        local avoid_len = strlen("`avoid_line'")
        local avoid_pad = int((`width' - `avoid_len')/2)
        local centered_avoid "{dup `avoid_pad': }{bf:`avoid_line'}"
    }
    
    * Display the centered message
    di as result "`border'"
    di as result "`centered_title'"
    di as result "`border'"
    di as result "`centered_results'"
    di as result "`centered_vars'"
    di as result "`centered_outliers'"
    di as result "`centered_sd'"
    if "`avoid'" != "" {
        di as result "`centered_avoid'"
    }
    di as result "`border'" _n(2)
end
