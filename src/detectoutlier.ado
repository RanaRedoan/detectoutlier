program define detectoutlier, rclass
    version 15.0

    syntax varlist(min=1) [if] [in], ///
        ADDVAR(varlist) ///
        SD(real 3) ///
        AVOID(numlist) ///
        USING(string)

    preserve

    // Initialize variables
    local row = 1
    local header = "firstrow(variables)"
    local sheetsettings = "sheetreplace"

    // Loop over each variable in varlist
    foreach var of varlist `varlist' {

        qui count if !missing(`var')
        if r(N) == 0 continue

        // Clean avoid values
        foreach badval of numlist `avoid' {
            qui replace `var' = . if `var' == `badval'
        }

        // Summary stats
        qui su `var' if !missing(`var')
        local mean = r(mean)
        local sdv = r(sd)

        // Flag outliers
        gen __outlier__ = 0
        replace __outlier__ = 1 if (`var' > (`mean' + `sd'*`sdv') | `var' < (`mean' - `sd'*`sdv')) & !missing(`var')

        qui count if __outlier__ == 1
        if r(N) == 0 {
            drop __outlier__
            continue
        }

        // Create metadata columns
        gen __variable__ = "`var'"
        local label : variable label `var'
        gen __label__ = "`label'"
        gen __value__ = `var'

        // Export to Excel
        cap export excel `addvar' __variable__ __label__ __value__ using "`using'" ///
            if __outlier__ == 1, sheet("Outlier") `sheetsettings' `header' cell("A`row'")

        // Update counters and cleanup
        local row = `row' + r(N)
        local sheetsettings = "sheetmodify"
        local header = ""

        drop __outlier__ __variable__ __label__ __value__
    }

    restore
end
