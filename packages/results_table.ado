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

  // Time-to-completion section.
  section_row , frame(`frame') title("Time-to-completion")

  // Insert time-to-completion rows into the table.
  foreach comparison of global comparisons {
    time_row `comparison' , frame(`frame')
  }

  // Make the table of main results.
  local note        ¹Data are means of samples restricted to completed reviews and may underestimate
  local note `note' resource use (person-hours) and time-to-completion (weeks) due to 
  local note `note' right-censoring of ongoing projects. ²Estimates are relative
  local note `note' resource use and relative time-to-completion, account for right-censored outcomes
  local note `note' and nonrandom endogenous treatment allocation, and are adjusted for planned
  local note `note' meta-analysis.
  frame `frame' {
    putdocx table results = data(*), varnames note("`note'") border(all, nil) layout(autofitcontents)
    // Format the table.
    putdocx table results(1,1) = ("Type of ML Use")
    putdocx table results(1,2) = ("Reviews")
    putdocx table results(1,3) = ("Sample Mean¹")
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

  // Get the levels of the comparison.
  levelsof `comparison'
  local levels `r(levels)'
  assert r(r) == 2

  // Get the Ns and sample means for the levels of the comparison and the level names.
  forvalues i = 1/2 {
    local this_level : word `i' of `levels'
    summarize log_resource1 if `comparison' == `this_level' & completed // TODO: Document that the sample means are restricted to completed reviews.
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
end

program time_row
  syntax varname(numeric fv) , frame(name local)
  local comparison `varlist'

  // Get the levels of the comparison.
  levelsof `comparison'
  local levels `r(levels)'
  assert r(r) == 2

  // Get the Ns and sample means for the levels of the comparison and the level names.
  forvalues i = 1/2 {
    local this_level : word `i' of `levels'
    summarize _t if `comparison' == `this_level' & completed // TODO: Document that the sample means are restricted to completed reviews.
    local n_`i' : disp `r(N)'
    local mean_`i' = r(mean)
    local mean_`i' : disp %3.1f `mean_`i''
    local name_`i' : label (`comparison') `this_level'
  }

  // Get the effect estimate, relative time-to-completion (i.e., ratio of total time under one treatment to the other).
  // We do this on the log scale and then exponentiate, which allows us to get a p-value that tests the null that
  // the log ratio is zero (equivalent to the ratio being one).
  estimate restore `comparison'_time
  nlcom log(_b[ATE:r2vs1.`comparison'] + _b[POmean:1.`comparison']) - log(_b[POmean:1.`comparison']), post
  lincom _nl_1 , eform
  local estimate : disp %3.2f `r(estimate)' " (" %3.2f `r(lb)' " to " %3.2f `r(ub)' ")"

  // Get the p-value.
  if r(p) < ${p_threshold} local p "<${p_threshold}"
  else                     local p : disp %-5.3f r(p)

  // Post the rows to the frame.
  frame post `frame' ("`name_1'") ("`n_1'") ("`mean_1'") ("`estimate'") ("`p'")
  frame post `frame' ("`name_2'") ("`n_2'") ("`mean_2'") ("")           ("")
end
