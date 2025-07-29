*! version 1.0.1 29Jul2024
program define detectoutlier
    version 16
    syntax varlist [if] [in] using/, [ADDvars(string) SD(real 3) AVOID(string)]

    preserve
    
    * Apply if/in conditions
    marksample touse
    qui keep if `touse'
    
    * Handle avoid values
    if "`avoid'" != "" {
        foreach var in `varlist' {
            foreach num in `avoid' {
                qui replace `var' = . if `var' == `num'
            }
        }
    }
    
    * Initialize Excel file
    loc row = 1
    loc header = "firstrow(variables)"
    loc sheetsettings = "sheetreplace"
    
    * Process each variable
    foreach var in `varlist' {
        qui count if !missing(`var')
        
        if r(N) > 0 {
            * Calculate statistics
            qui sum `var', detail
            loc mean = r(mean)
            loc sd_val = r(sd)
            
            * Identify outliers
            gen outlier = 0
            replace outlier = 1 if ((`var' > (`mean' + `sd'*`sd_val')) | ///
                                 (`var' < (`mean' - `sd'*`sd_val'))) & !missing(`var')
            
            * Prepare for export
            gen variable = "`var'"
            loc label : var label `var'
            gen label = "`label'"
            gen value = `var'
            
            * Export to Excel
            if "`addvars'" != "" {
                cap export excel `addvars' variable label value using "`using'" ///
                    if outlier == 1, sheet("Outlier") `sheetsettings' `header' cell("A`row'")
            }
            else {
                cap export excel variable label value using "`using'" ///
                    if outlier == 1, sheet("Outlier") `sheetsettings' `header' cell("A`row'")
            }
            
            * Update row counter
            qui count if outlier == 1
            loc row = `row' + r(N) + 1
            
            * Clean up
            drop variable label value outlier
            loc header = ""
            loc sheetsettings = "sheetmodify"
        }
    }
    
    restore
end
