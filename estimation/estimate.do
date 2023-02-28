version 16.1

// Perform estimation.
foreach analysis of global analyses {
  // Perform estimation and store the estimates.
  ${`analysis'_model}
  assert e(converged)
  estimates store `analysis'

  // Compute and test residuals for normality for eintreg.
  if "`e(cmd)'" == "eintreg" {
    tempvar y_hat resid
    predict `y_hat'
    local y : word 1 of `e(depvar)'
    generate `resid' = `y' - `y_hat' if completed // Limit to uncensored observations.
    swilk `resid'
    assert r(p) > 0.05
  }
}

// TODO: Based on a comparison of histograms of residuals, QQ plots, and Shapiro-Wilk and Shapiro-Francia tests,
// TODO: we should model resource use on the
// TODO: natrual (non-logged) scale. Then we can either present mean difference and/or the ratio.

// TODO: Plot the Kaplan Meier like so:
// TODO: The colors and their ordering come from: https://www.stata.com/statalist/archive/2011-02/msg00692.html
// sts graph , by(rec_vs_none) ci risktable censored(number) ci1opts(fcolor(navy%20)) ci2opts(fcolor(maroon%20))