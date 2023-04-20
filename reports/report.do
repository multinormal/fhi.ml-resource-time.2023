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
Normality of residuals from the analyses of resource use were assessed using 
the Shapiro-Wilk test. To aid generalization to other institutions, we 
re-expressed analysis results as estimates of ratios (relative resource 
use and relative time-to-completion). We did this by exponentiating differences 
in mean log resource use, and by computing ratios of mean times-to-completion 
using the delta method. We present two-sided 95% confidence intervals and 
p-values where appropriate and use a prespecified p < 0.05 significance 
criterion throughout. We also present the time-to-completion data using 
Kaplan-Meier estimates of survivor functions (but note that these do not account 
for nonrandom endogenous treatment assignment and are not adjusted for planned 
meta-analysis).
putdocx textblock end

`heading'
putdocx text ("Protocol Deviations")

`newpara'
It was not possible to model nonrandom endogenous treatment assignment using 
both prespecified variables (field and prespecification) in the analyses of 
resource use because the models did not converge. We therefore used one of 
the two variables, choosing the variable with the smallest standard error 
in the model of treatment assignment. Endogenous assignment of any or 
recommended ML was modelled by field (welfare reviews were generally more 
likely to use ML) and recommended ML use was modelled by prespecification 
(reviews with protocols were generally less likely to use recommended ML).
putdocx textblock end

`newpara'
We updated the preprint version of the protocol during data extraction but before starting the 
analysis or unblinding the statistician (CJR) to redefine the comparisons in terms of under- and 
overuse of machine learning. However, too few reviews were judged to have 
under- or overused ML, so it was not possible to run these analyses. We 
therefore performed and report the analyses as originally planned.
putdocx textblock end

// Start a new page.
putdocx pagebreak

// Results section
`heading'
putdocx text ("Results")

// Insert the table of results.
results_table

`newpara' // TODO: This text is not automatically generated.
The strength of evidence for endogeneity varied by comparison. For example, 
the correlation between use of any versus no ML and resource use was 0.95 
(95% CI 0.25 to 1.00; p<0.0001) while that for recommended versus 
no ML use was 0.01 (95% CI -0.97 to 0.97; p=0.99). However, as far as possible, 
we chose to account for possible endogeneity according to our protocol.
putdocx textblock end

`newpara' // TODO: This text is not automatically generated.
Due to the smaller than anticipated sample size, none of the effect estimates were 
sufficiently precise to be able to conclude that use of recommended or any ML is 
associated with more or less resource use, or longer or shorter time-to-completion, 
compared to no or non-recommended ML use (i.e., all confidence intervals include the 
null). For resource use, point estimates favor recommended and any ML use over 
non-recommended and no ML use, while no ML use is favored over recommended ML use. 
For time-to-completion, point estimates favor recommended and any ML use over 
no ML use, while non-recommended ML use is favored over recommended ML use. The 
estimates are generally but not always consistent with the sample means and 
Kaplan-Meier plots. However, the sample means may be quite misleading due to 
possible confounding (nonrandom endogenous treatment assignment), do not account 
for censoring, and are not adjusted for the effect of planned meta-analysis, which 
is associated with more resource use and longer time-to-completion. The Kaplan-Meier 
plots show censored reviews, but do not account for endogeneity and are not adjusted 
for planned meta-analysis. Recall that we estimated ratios of means, while Kaplan-Meier 
plots are generally interpreted in terms of quantiles (e.g., median 
time-to-completion).
putdocx textblock end

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

// Discussion section
`heading'
putdocx text ("Discussion")

`newpara' // TODO: This text is not automatically generated.
Results for the resource use outcome are a little challenging to interpret. The effect 
estimates suggest that recommended or any ML use is associated with less resource use 
compared to non-recommended or no ML use, but the sample means for the any versus no ML use 
comparison suggest the opposite (but could be quite misleading). The effect estimate suggests that 
recommended ML use is associated with substantially more resource use compared to no ML use, 
and this is also reflected by the sample means. We find this result quite surprising, but it 
could be explained by confounding that we have not been able to account for. For example, 
perhaps reviews that did not use ML did not do so because they were judged to be "easy", and 
"easy" reviews are not resource intensive.
putdocx textblock end

`newpara' // TODO: This text is not automatically generated.
Results for the time-to-completion outcome are somewhat easier to interpret. The effect 
estimates suggest that recommended or any ML use is associated with shorter time-to-completion 
compared to no ML use. These results are consistent with our experience and with one of 
the associated sets of sample means. The point estimate for the recommended versus 
non-recommended comparison slightly favors non-recommended ML use, but the sample means 
strongly suggest otherwise. Because the estimate is imprecise, and the point estimate is 
close to the null, it would not surprise us if the direction of effect is wrong.
putdocx textblock end

`newpara' // TODO: This text is not automatically generated.
We think the results for the time-to-completion outcome are somewhat easier to interpret than 
those for resource use because review commission and completion dates (which are used to 
define time-to-completion) are well-defined and easy to measure, while resource use is essentially 
a self-reported outcome. Researchers at our institute use a web- or mobile app-based system 
to allocate hours worked to specific projects. There is likely to be inter-researcher 
differences in reporting, which could lead to substantial variation in outcome measurements. 
In addition, confounding may occur if researchers who under- or over-allocate hours are also more likely to 
use or not use ML. While confounding may also occur for time-to-completion outcomes, it may be 
easier to account for in analysis. For these reasons, we suggest that future studies specify 
well-defined time-to-completion outcomes as being of primary interest.
putdocx textblock end

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
