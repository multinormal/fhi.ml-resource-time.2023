version 16.1
set graphics off

// Specify options for the KM plots.
local opts        ci ci1opts(fcolor(navy%20)) ci2opts(fcolor(maroon%20)) // Translucent CI bands.
local opts `opts' risktable censored(number)                             // Risk table and indicate number of censorings.

// Make a Kaplan-Meier plot for each comparison.
foreach comparison of global comparisons {  
  // Get the name of the comparison for the filename and figure title.
  local comparison_name : variable label `comparison'
  local title "Time-to-completion for `comparison_name'"

  // Make the figure.
  sts graph , by(`comparison') `opts' title("Time-to-completion for" "`comparison_name'")
  
  // Save the figure in the required formats.
  foreach format in /*png*/ pdf { // TODO: Add png and TIFF with compression via sips.
    local width ""
    if "`format'" == "png" local width width(3000)
    local filename "products/Time-to-completion for `comparison_name'.`format'"
    graph export "`filename'" , `width' replace
  }
}

set graphics on
