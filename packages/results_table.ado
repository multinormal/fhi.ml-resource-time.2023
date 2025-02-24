version 18

program results_table
  tempname frame
  frame create `frame' strL(type n mean es p)

  // Resource use section.
  section_row , frame(`frame') title("Resource Use")
  
  // Insert resource use rows into the table.
  foreach comparison of global comparisons {
    resource_row `comparison' , frame(`frame')
  }

  // Time-to-completion section.
  section_row , frame(`frame') title("Time-to-completion")

  // Insert time-to-completion rows into the table.
  foreach comparison of global comparisons {
    time_row `comparison' , frame(`frame')
  }

  // Make the table of main results.
  local note        ¹Data are means of samples restricted to completed (uncensored) reviews and
  local note `note' do not account for nonrandom endogenous treatment allocation.
  local note `note' ²Estimates are relative resource use and relative time-to-completion, and account 
  local note `note' for right-censored outcomes and nonrandom endogenous treatment allocation.
  local note `note' An effect estimate < 1 indicates that recommended or any ML use is associated with
  local note `note' less resource use or shorter time-to-completion than to the comparator.
  local note `note' All estimates are adjusted for planned meta-analysis.
  frame `frame' {
    putdocx table results = data(*), varnames note("`note'") border(all, nil) layout(autofitcontents)
    // Format the table.
    putdocx table results(1,1) = ("Type of ML Use")
    putdocx table results(1,2) = ("Reviews")
    putdocx table results(1,3) = ("Mean (SD)¹")
    putdocx table results(1,4) = ("Effect Estimate²")
    putdocx table results(1,5) = ("p-value")
    putdocx table results(2,3) = ("Person-hours")
    putdocx table results(9,3) = ("Weeks")
    putdocx table results(1,.), border(top)
    putdocx table results(1 2 8 9,.), border(bottom)
    putdocx table results(4 6 11 13, .), border(bottom)
    local end = _N + 1
    putdocx table results(`end',.), border(bottom)
    putdocx table results(.,.), font("Calibri (Body)", 8)
    putdocx table results(1,.), bold
    putdocx table results(2 9,1), bold
  }
end

program section_row
  syntax , frame(name local) title(string)
  frame post `frame' ("`title'") ("") ("") ("") ("")
end

program resource_row
  syntax varname(numeric fv) , frame(name local)
  local comparison `varlist'

  // Get the number of reviews included in the analysis for the comparison.
  count if !missing(`comparison')
  local sample_size = r(N)

  // Get the levels of the comparison.
  levelsof `comparison'
  local levels `r(levels)'
  assert r(r) == 2

  // Get the Ns and sample means and SDs for the levels of the comparison and the level names.
  forvalues i = 1/2 {
    local this_level : word `i' of `levels'
    count if `comparison' == `this_level'
    local n_`i' : disp `r(N)' "/`sample_size'" 

    // Compute the sample mean using non-logged values.
    tempvar log_resource
    generate `log_resource' = exp(log_resource1)
    summarize `log_resource' if `comparison' == `this_level' & completed
    local mean_`i' = r(mean) // Mean on the natural scale.
    local sd_`i' = r(sd) // SD on the natural scale.
    local mean_`i' : disp %3.0f `mean_`i'' " (" %3.0f `sd_`i'' ")"
    local name_`i' : label (`comparison') `this_level'
  }

  // Get the effect estimate, relative resource use via exponentiation.
  estimate restore `comparison'_resource
  local contrast 1 // The comparisons are indicators, where 1 indicates our preferred ML use.
  lincom `contrast'.`comparison' , eform
  local estimate : disp %3.2f `r(estimate)' " (" %3.2f `r(lb)' " to " %3.2f `r(ub)' ")"

  // Get the p-value.
  if r(p) < ${p_threshold} local p "<${p_threshold}"
  else                     local p : disp %-5.3f r(p)

  // Post the rows to the frame.
  frame post `frame' ("`name_1'") ("`n_1'") ("`mean_1'") ("`estimate'") ("`p'")
  frame post `frame' ("`name_2'") ("`n_2'") ("`mean_2'") ("")           ("")
end

program time_row
  syntax varname(numeric fv) , frame(name local)
  local comparison `varlist'

  // Get the number of reviews included in the analysis for the comparison.
  count if !missing(`comparison')
  local sample_size = r(N)

  // Get the levels of the comparison.
  levelsof `comparison'
  local levels `r(levels)'
  assert r(r) == 2

  // Get the Ns and sample means for the levels of the comparison and the level names.
  forvalues i = 1/2 {
    local this_level : word `i' of `levels'
    count if `comparison' == `this_level'
    local n_`i' : disp `r(N)' "/`sample_size'" 
    summarize _t if `comparison' == `this_level' & completed
    local mean_`i' = r(mean)
    local sd_`i' = r(sd)
    local mean_`i' : disp %3.1f `mean_`i'' " (" %2.1f `sd_`i'' ")"
    local name_`i' : label (`comparison') `this_level'
  }

  // Get the effect estimate, relative time-to-completion (i.e., ratio of total time under one treatment to the other).
  // We do this on the log scale and then exponentiate, which allows us to get a p-value that tests the null that
  // the log ratio is zero (equivalent to the ratio being one).
  estimate restore `comparison'_time
  nlcom log(_b[ATE:r1vs0.`comparison'] + _b[POmean:0.`comparison']) - log(_b[POmean:0.`comparison']), post
  lincom _nl_1 , eform
  local estimate : disp %3.2f `r(estimate)' " (" %3.2f `r(lb)' " to " %3.2f `r(ub)' ")"

  // Get the p-value.
  if r(p) < ${p_threshold} local p "<${p_threshold}"
  else                     local p : disp %-5.3f r(p)

  // Post the rows to the frame.
  frame post `frame' ("`name_1'") ("`n_1'") ("`mean_1'") ("`estimate'") ("`p'")
  frame post `frame' ("`name_2'") ("`n_2'") ("`mean_2'") ("")           ("")
end
