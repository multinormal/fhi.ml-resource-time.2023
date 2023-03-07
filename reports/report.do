version 16.1

// Some locals to make this file a little more readable.
local heading putdocx paragraph, style(Heading1)
local subhead putdocx paragraph, style(Heading2)
local newpara putdocx textblock begin, halign(both)
local putdocx textblock end putdocx textblock end

local p_fmt  %5.2f // Format used for P-values.
local e_fmt  %5.2f // Format used for estimates.
local pc_fmt %8.1f // Format used for percentages.

// Start the document.
putdocx begin

// Title.
putdocx paragraph, style(Title)
putdocx text ("The effect of machine learning tools for evidence synthesis on resource use and time-to-completion")

// Author and revision information.
`newpara'
Chris Rose, Norwegian Institute of Public Health 
(<<dd_docx_display: c(current_date)>>)
putdocx textblock end
`newpara'
Generated using git revision: <<dd_docx_display: "${git_revision}">>
putdocx textblock end

// Methods section
`heading'
putdocx text ("Methods")

`newpara'
Except as noted below, we analyzed the data as specified in the protocol using Stata 16 (StataCorp LLC, College 
Station, Texas, USA). Briefly, we analyzed resource use (person-hours) on the log scale 
using extended interval regression (eintreg) and used a likelihood-adjusted-censoring 
inverse-probability-weighted regression adjustment model (LAC-IPWRA; stteffects) to estimate mean 
differences in time-to-completion. Ongoing reviews were right censored at the end of data collection 
(31 January 2023) and all analyses accounted for this censoring. We had no reason to suspect informative 
(nonrandom) censoring, so did not model a censoring mechanism. Because we did not 
randomize reviews to use recommended ML versus no ML (for example), we modelled ML use as an endogenously 
assigned treatment predicted by field (healthcare or welfare) and pre-specification (existence 
of a protocol), as planned, in all analyses except that for the secondary analysis recommended versus 
non-recommended ML use with respect to resource use. While there was some statistically significant evidence 
of endogeneity from the corresponding time-to-completion analysis and an exploratory logistic regression, the estimate of 
relative resource use obtained using the planned model appeared to dramatically overestimate the 
effect of recommended ML use. We therefore used a model for this analysis that did not account for 
possible endogeneity. We re-expressed all estimates as ratios (relative resource use and relative 
time-to-completion) to aid generalization to other institutions. We present two-sided 95% confidence 
intervals and p-values where appropriate and use a prespecified p < 0.05 significance criterion 
throughout. We also present the time-to-completion data using Kaplan-Meier estimates of survivor functions.
putdocx textblock end

// Start a new page.
putdocx pagebreak

// Results section
`heading'
putdocx text ("Results")

// Insert the table of results.
results_table

// Start a new page.
putdocx pagebreak

// Insert the Kaplan-Meier plots.
foreach comparison of global comparisons {
  local comparison_name : variable label `comparison'
  local title "Kaplan-Meier estimates for `comparison_name'"

  `subhead'
  putdocx text ("`title'")
  putdocx image "products/Time-to-completion for `comparison_name'.png", linebreak
}

// References
`heading'
putdocx text ("References")

`newpara'
TODO: Add references.
putdocx textblock end

// Appendices

`heading'
putdocx text ("Appendix 1 — Protocol Deviations")

`newpara'
We updated the preprint version of the protocol during data extraction but before starting the 
analysis or unblinding the statistician (CJR) to redefine the comparisons in terms of under- and 
overuse of machine learning (TODO: Cite revision). However, only two reviews were judged to have 
under- or overused machine learning, so it was not possible to perform the revised analyses. We 
therefore performed and report the analyses as originally planned.
putdocx textblock end

`heading'
putdocx text ("Appendix 2 — Full Regression Results")

foreach comparison of global comparisons {
  foreach outcome of global outcomes {
    `subhead'
    putdocx text ("Regression results for `comparison' with respect to `outcome'")

    estimates restore `comparison'_`outcome'
    estimates replay `comparison'_`outcome'
    putdocx table `comparison'_`outcome' = etable
  }
}



// Save the report to the specified filename.
putdocx save "${report_filename}", replace
