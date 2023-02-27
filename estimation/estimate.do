version 16.1

// TODO: Perform estimation.

// Specify the assumed endogeneous treatment assignment model.
// TODO: Check if synthesis_planned corresponds to pre-specification.
// TODO: nointeract is necessary to achieve convergence
local entreat rec_vs_none = i.field i.synthesis_planned , nointeract

// Resource use: Mean relative number of person-hours used.
eintreg log_resource1 log_resource2 i.meta_analysis_planned , entreat(`entreat')
assert e(converged)

// TODO: Based on a comparison of histograms of residuals, QQ plots, and Shapiro-Wilk and Shapiro-Francia tests,
// TODO: we should model resource use on the
// TODO: natrual (non-logged) scale. Then we can either present mean difference and/or the ratio.

// TODO: Plot the Kaplan Meier like so:
// TODO: The colors and their ordering come from: https://www.stata.com/statalist/archive/2011-02/msg00692.html
// sts graph , by(rec_vs_none) ci risktable censored(number) ci1opts(fcolor(navy%20)) ci2opts(fcolor(maroon%20))