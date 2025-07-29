program define detectoutlier
    version 15.1
    syntax varlist(min=1 numeric) [, addvar(varlist) sd(real 3) using(string)]
    
    // Check if using option is specified
    if "`using'" == "" {
        di as error "using option required"
        exit 198
    }
    
    // Check if file extension is .xlsx
    if !regexm("`using'", "\.xlsx$") {
        di as error "Output file must have .xlsx extension"
        exit 198
    }
    
    // Preserve original data
    preserve
    
    // Initialize temporary variables
    tempvar mean sd lower upper outlier
    tempname results
    
    // Create temporary file to store results
    tempfile tempout
    postfile `results' str32 variable str244 varlabel `addvar' double value using `tempout'
    
    // Loop through each variable in varlist
    foreach var of varlist `varlist' {
        // Calculate mean and standard deviation
        quietly summarize `var'
        scalar `mean' = r(mean)
        scalar `sd' = r(sd)
        
        // Calculate outlier bounds
        scalar `lower' = `mean' - `sd' * `r(sd)'
        scalar `upper' = `mean' + `sd' * `r(sd)'
        
        // Generate outlier indicator
        quietly gen `outlier' = (`var' < `lower' | `var' > `upper') & !missing(`var')
        
        // Get variable label
        local varlabel: variable label `var'
        if "`varlabel'" == "" local varlabel "`var'"
        
        // Post outlier observations to results
        quietly levelsof _n if `outlier', local(obs)
        foreach i of local obs {
            local val = `var'[`i']
            local postcmd "post `results' ("`var'") ("`varlabel'") "
            foreach addv of varlist `addvar' {
                local val`addv' = `addv'[`i']
                local postcmd "`postcmd' (`val`addv'') "
            }
            local postcmd "`postcmd' (`val')"
            quietly `postcmd'
        }
        
        // Drop temporary outlier variable
        quietly drop `outlier'
    }
    
    // Close postfile
    postclose `results'
    
    // Export results to Excel
    use "`tempout'", clear
    if _N > 0 {
        rename (variable varlabel value) (Variable_Name Variable_Label Outlier_Value)
        order Variable_Name Variable_Label `addvar' Outlier_Value
        export excel using "`using'", firstrow(variables) replace
        di as text "Outliers exported to `using'"
    }
    else {
        di as text "No outliers detected"
    }
    
    // Restore original data
    restore
end