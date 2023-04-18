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
Except as noted in Protocol Deviations, the statistical analyses were performed 
as specified in our protocol using Stata 16 (StataCorp LLC, College Station, Texas, USA). 
The study is retrospective, and reviews were not randomized to use recommended ML versus 
no ML (for example). We therefore modelled ML use as an endogenously assigned 
treatment predicted by field (healthcare or welfare) and prespecification 
(existence of a protocol). Resource use was analyzed using 
extended interval regression (Stata's eintreg command) and time-to-completion 
was analyzed using a likelihood-adjusted-censoring inverse-probability-weighted 
regression adjustment model (LAC-IPWRA; Stata's stteffects command). Ongoing 
reviews were right censored at the end of data collection (31 January 2023) 
and all analyses accounted for this censoring. We had no reason to suspect 
informative (nonrandom) censoring, so did not model a censoring mechanism. 
We re-expressed all estimates as ratios (relative resource use and relative 
time-to-completion) to aid generalization to other institutions. We did this 
by exponentiating differences in log resource use, and by computing ratios of 
mean times-to-completion using the delta method. We present two-sided 
95% confidence intervals and p-values where appropriate and use a 
prespecified p < 0.05 significance criterion throughout. We also 
present the time-to-completion data using Kaplan-Meier estimates of survivor 
functions (but note that these do not account for nonrandom endogenous treatment 
assignment).
putdocx textblock end

`heading'
putdocx text ("Protocol Deviations")

`newpara'
It was not possible to model nonrandom endogenous treatment assignment using 
both prespecified variables (field and prespecification) in the analyses of 
resource use. We therefore used one of the two variables, choosing the variable 
with smallest standard error. Endogeneous assignment of any or recommended ML 
was modelled by field (welfare reviews were generally more likely to use ML) and 
recommended ML use was modelled by prespecification (reviews with protocols were 
generally less likely to use recommended ML). While, the evidence for endogeneity 
was weak (e.g., p=0.06), we chose to account for the possiblity and follow our protocol 
where possible.
putdocx textblock end

`newpara'
We updated the preprint version of the protocol during data extraction but before starting the 
analysis or unblinding the statistician (CJR) to redefine the comparisons in terms of under- and 
overuse of machine learning. However, only two reviews were judged to have 
under- or overused machine learning, so it was not possible to perform the revised analyses. We 
therefore performed and report the analyses as originally planned.
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

`heading'
putdocx text ("Appendix — Full Regression Results")

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
