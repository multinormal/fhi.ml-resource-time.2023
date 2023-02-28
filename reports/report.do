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
Analyses were performed as specified in the protocol using Stata 16 (StataCorp LLC, College 
Station, Texas, USA). Briefly, we analyzed resource use (person-hours) on the log scale 
using extended interval regression (eintreg) and used a likelihood-adjusted-censoring 
inverse-probability-weighted regression adjustment (LAC-IPWRA; stteffects) model to estimate mean 
difference in time-to-completion. All analyses accounted for right-censored outcomes (ongoing reviews) 
and for nonrandom endogenous treatment allocation, which was modelled in terms of review field (welfare 
or healthcare) and whether any evidence synthesis (quantitative or qualitative) was planned. We 
re-expressed the estimates as ratios (relative resource use and relative time-to-completion) to aid 
generalization to other institutions. We present two-sided 95% confidence intervals and p-values 
where appropriate and interpret p-values less than 0.05 to be statistically significant. We also 
present the time-to-completion data using Kaplan-Meier estimates of survivor functions. We updated 
the preprint version of the protocol during data extraction but before starting the analysis or unblinding the 
statistician (CJR) to redefine the comparisons in terms of under- and overuse of machine learning 
(TODO: Cite revision). However, only two reviews were judged to have under- or overused machine 
learning, so it was not possible to perform the revised analyses. We therefore performed and report 
the analyses as originally planned.
putdocx textblock end

// Results section
`heading'
putdocx text ("Results")

`newpara'
TODO: Add results.
putdocx textblock end

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
TODO: Describe any protocol deviations.
putdocx textblock end

`heading'
putdocx text ("Appendix 2 — Full Regression Results")

`newpara'
TODO: Present full regression tables.
putdocx textblock end

// Save the report to the specified filename.
putdocx save "${report_filename}", replace
