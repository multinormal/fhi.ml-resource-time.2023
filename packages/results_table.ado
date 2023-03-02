version 16.1

program results_table
  tempname frame
  frame create `frame' strL(type n mean es p)

  // Resource use section.
  section_row , frame(`frame') title("Resource Use")
  
  // Insert resource use rows into the table.
  foreach comparison of global comparisons {
    resource_row `comparison' , frame(`frame')
  }

  // TODO: Insert time-to-completion rows into the table.
end

program section_row
  syntax , frame(name local) title(string)
  frame post `frame' ("`title'") ("") ("") ("") ("")
end

program resource_row
  syntax varname(numeric fv) , frame(name local)
  local comparison `varlist'

  // Get the levels of the comparison.
  levelsof `comparison'
  local levels `r(levels)'
  assert r(r) == 2

  // Get the Ns and sample means for the levels of the comparison and the level names.
  forvalues i = 1/2 {
    local this_level : word `i' of `levels'
    summarize log_resource1 if `comparison' == `this_level'
    local n_`i' : disp `r(N)'
    local mean_`i' = exp(r(mean))
    local mean_`i' : disp %3.0f `mean_`i''
    local name_`i' : label (`comparison') `this_level'
  }

  // Get the effect estimate, relative resource use via exponentiation.
  estimate restore `comparison'_resource
  local contrast : word 2 of `levels' // TODO: After unblinding, replace this with known base levels via fvset or similar.
  lincom `contrast'.`comparison' , eform
  local estimate : disp %3.2f `r(estimate)' " (" %3.2f `r(lb)' " to " %3.2f `r(ub)' ")"

  // Get the p-value.
  if r(p) < ${p_threshold} local p "<${p_threshold}"
  else                     local p : disp %-5.3f r(p)

  // Post the rows to the frame.
  frame post `frame' ("`name_1'") ("`n_1'") ("`mean_1'") ("`estimate'") ("`p'")
  frame post `frame' ("`name_2'") ("`n_2'") ("`mean_2'") ("")           ("")

  frame `frame': list // TODO: Remove
end
