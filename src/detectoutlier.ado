program define detectoutlier
    version 15.1
    syntax varlist(min=1 numeric) [, addvar(varlist) sd(real 3) using(string) avoid(numlist)]
    
    // Check if using option is specified
    if "`using'" == "" {
        display as error "using option required"
        exit 198
    }
    
    // Check if file extension is .xlsx
    if !regexm("`using'", "\.xlsx$") {
        display as error "Output file must have .xlsx extension. Specified: `using'"
        exit 198
    }
    
    // Preserve original data
    preserve
    
    // Initialize temporary variables
    tempvar mean sd lower upper outlier value
    tempname results
    tempfile tempout
    
    // Initialize row counter and Excel settings
    local row = 1
    local header = "firstrow(variables)"
    local sheetsettings = "sheetreplace"
    
    // Create temporary file to store results
    postfile `results' str32 variable str244 varlabel `addvar' double value using `tempout'
    
    // Loop through each variable in varlist
    foreach var of varlist `varlist' {
        // Check if variable has non-missing observations
        quietly count if `var' != .
        if r(N) > 0 {
            // Temporarily set avoid values to missing
            if "`avoid'" != "" {
                foreach val of numlist `avoid' {
                    quietly replace `var' = . if `var' == `val'
                }
            }
            
            // Calculate mean and standard deviation
            quietly summarize `var'
            scalar `mean' = r(mean)
            scalar `sd' = r(sd)
            
            // Calculate outlier bounds
            scalar `lower' = `mean' - `sd' * r(sd)
            scalar `upper' = `mean' + `sd' * r(sd)
            
            // Generate outlier indicator
            quietly gen `outlier' = (`var' < `lower' | `var' > `upper') & !missing(`var')
            quietly gen `value' = `var'
            
            // Get variable label
            local varlabel : variable label `var'
            if "`varlabel'" == "" local varlabel "`var'"
            
            // Post outlier observations to results
            quietly levelsof _n if `outlier', local(obs)
            foreach i of local obs {
                local val = `value'[`i']
                local postcmd "post `results' (`"`var'"') (`"`varlabel'"') "
                foreach addv of varlist `addvar' {
                    local val`addv' = `addv'[`i']
                    local postcmd "`postcmd' (`"`val`addv''"') "
                }
                local postcmd "`postcmd' (`val')"
                quietly `postcmd'
            }
            
            // Drop temporary variables
            quietly drop `outlier' `value'
        }
    }
    
    // Close postfile
    postclose `results'
    
    // Export results to Excel
    use "`tempout'", clear
    if _N > 0 {
        rename (variable varlabel value) (Variable_Name Variable_Label Outlier_Value)
        order Variable_Name Variable_Label `addvar' Outlier_Value
        capture export excel using "`using'", sheet("Outlier") `sheetsettings' `header' cell("A`row'")
        if _rc != 0 {
            display as error "Failed to export to Excel. Error code: " _rc
            exit _rc
        }
        display as text "Outliers exported to `using'"
    }
    else {
        display as text "No outliers detected"
    }
    
    // Restore original data
    restore
end
