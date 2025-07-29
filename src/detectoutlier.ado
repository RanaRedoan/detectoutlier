program define detectoutlier, rclass
    version 15.0

    // Capture varlist and using filename manually
    gettoken first tok : 0, parse(" ,")
    local varlist `first'

    gettoken second tok : tok, parse(" ,")
    if "`second'" != "using" {
        di as err "syntax: detectoutlier varlist using filename, [options]"
        exit 198
    }

    // Get the using file
    gettoken usingfile rest : tok, parse(" ,")
    local usingfile = subinstr(`"`usingfile'"', `"""', "", .)  // remove quotes if any

    // Now parse the remaining options
    syntax [, ADDVAR(varlist) SD(real 3) AVOID(numlist)]

    // Default SD
    if missing(`sd') {
        local sd = 3
    }

    preserve

    // Initialize Excel settings
    local row = 1
    local header = "firstrow(variables)"
    local sheetsettings = "sheetreplace"

    // Loop through all variables in varlist
    foreach var of varlist `varlist' {

        qui count if !missing(`var')
        if r(N) == 0 continue

        // Replace avoid values with missing
        foreach badval of numlist `avoid' {
            quietly replace `var' = . if `var' == `badval'
        }

        // Summarize
        quietly summarize `var' if !missing(`var')
        local mean = r(mean)
        local sdv  = r(sd)

        // Outlier logic
        gen __outlier__ = 0
        replace __outlier__ = 1 if (`var' > (`mean' + `sd'*`sdv') | `var' < (`mean' - `sd'*`sdv')) & !missing(`var')

        count if __outlier__ == 1
        if r(N) == 0 {
            drop __outlier__
            continue
        }

        // Add meta columns
        gen __variable__ = "`var'"
        local label : variable label `var'
        gen __label__ = "`label'"
        gen __value__ = `var'

        // Export outliers
        cap export excel `addvar' __variable__ __label__ __value__ using "`usingfile'" ///
            if __outlier__ == 1, sheet("Outlier") `sheetsettings' `header' cell("A`row'")

        local row = `row' + r(N)
        local sheetsettings = "sheetmodify"
        local header = ""

        drop __outlier__ __variable__ __label__ __value__
    }

    restore
end
