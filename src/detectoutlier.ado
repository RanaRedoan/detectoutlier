program define detectoutlier
    version 15.0
    syntax varlist(min=1) [ , addvar(varlist) sd(real 2.5) avoid(numlist) outfile(string) ]

    tempvar flag
    local avoidlist `avoid'
    local addvars `addvar'
    local outfile "`outfile'"

    preserve

    foreach var of varlist `varlist' {
        qui gen double mean_`var' = mean(`var')
        qui gen double sd_`var' = sd(`var')
        qui gen byte outlier_`var' = 0

        qui foreach val of numlist `avoidlist' {
            replace outlier_`var' = . if `var' == `val'
        }

        qui replace outlier_`var' = 1 if abs(`var' - mean_`var') > `sd' * sd_`var' & outlier_`var' != .
    }

    keep `addvars' `varlist' outlier_*
    export excel using "`outfile'", firstrow(variables) replace

    restore
end
