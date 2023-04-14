version 16.1
set graphics off

// Specify options for the KM plots.
local opts        ci ci1opts(fcolor(navy%20)) ci2opts(fcolor(maroon%20)) // Translucent CI bands.
local opts `opts' risktable(, title("Incomplete Reviews"))               // Title.
local opts `opts' censored(number)                                       // Indicate number of censorings.
local opts `opts' xtitle("Weeks After Review Commission")                // X-axis title.
local opts `opts' ylabel(0 "0%" 0.25 "25%" 0.5 "50%" 0.75 "75%" 1 "100%", angle(0) nogrid) // Y-axis ticks etc.
local opts `opts' ytitle("Completed Reviews (95% CI)")

// Make a Kaplan-Meier plot for each comparison.
foreach comparison of global comparisons {  
  // Get the name of the comparison for the filename and figure title.
  local comparison_name : variable label `comparison'

  // Specify the risk table row titles.
  levelsof `comparison'
  assert r(r) == 2
  local levels `r(levels)'
  local risktable ""
  forvalues i = 1/2 {
    local this_level : word `i' of `levels'
    local rowtitle : label (`comparison') `this_level'
    local risktable `risktable' risktable(, rowtitle("`rowtitle'") group(`this_level'))
  }

  // Make the figure.
  sts graph , failure by(`comparison') `opts' `risktable' title("")
  
  // Save the figure in the required formats.
  foreach format in png pdf { // TODO: Add TIFF with compression via sips.
    local width ""
    if "`format'" == "png" local width width(3000)
    local filename "products/Time-to-completion for `comparison_name'.`format'"
    graph export "`filename'" , `width' replace
  }
}

set graphics on
