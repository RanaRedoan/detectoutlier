program define detectoutlier, rclass
    version 15.0

    // Parse: varlist using filename, then options
    syntax varlist(min=1) using/, ///
        ADDVAR(varlist) ///
        SD(real 3) ///
        AVOID(numlist)

    preserve

    // Extract Excel filename from using
    local outfile `"`using'"'

    // Initialize Excel export settings
    local row = 1
    local header = "firstrow(variables)"
    local sheetsettings = "sheetreplace"

    // Loop over each variable in the varlist
    foreach var of varlist `varlist' {
        
        qui count if !missing(`var')
        if r(N) == 0 continue

        // Handle avoid values: convert them to missing
        foreach badval of numlist `avoid' {
            qui replace `var' = . if `var' == `badval'
        }

        // Summary statistics
        qui su `var' if !missing(`var')
        local mean = r(mean)
        local sdv  = r(sd)

        // Flag outliers using SD threshold
        gen __outlier__ = 0
        replace __outlier__ = 1 if (`var' > (`mean' + `sd'*`sdv') | `var' < (`mean' - `sd'*`sdv')) & !missing(`var')

        qui count if __outlier__ == 1
        if r(N) == 0 {
            drop __outlier__
            continue
        }

        // Add metadata columns
        gen __variable__ = "`var'"
        local label : variable label `var'
        gen __label__ = "`label'"
        gen __value__ = `var'

        // Export detected outliers to Excel
        cap export excel `addvar' __variable__ __label__ __value__ using "`outfile'" ///
            if __outlier__ == 1, sheet("Outlier") `sheetsettings' `header' cell("A`row'")

        // Update row counter for next export
        local row = `row' + r(N)
        local sheetsettings = "sheetmodify"
        local header = ""

        drop __outlier__ __variable__ __label__ __value__
    }

    restore
end
