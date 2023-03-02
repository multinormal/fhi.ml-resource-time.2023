version 16.1

// Perform estimation.
foreach comparison of global comparisons {
  foreach outcome of global outcomes {
    disp "{hline}"
    disp as result "Analysis for: {ul:`comparison'} with respect to {ul:`outcome'}"

    // Perform estimation and store the estimates.
    ${`comparison'_`outcome'_model}
    assert e(converged)
    estimates store `comparison'_`outcome'

    // Compute and test residuals for normality for eintreg.
    if regexm("`e(cmd)'", "intreg") { // Match eintreg and intreg.
      tempvar y_hat resid
      predict `y_hat'
      local y : word 1 of `e(depvar)'
      generate `resid' = `y' - `y_hat' if completed // Limit to uncensored observations.
      swilk `resid'
      assert r(p) > 0.05
    }
  }
}

// TODO: Plot the Kaplan Meier like so:
// TODO: The colors and their ordering come from: https://www.stata.com/statalist/archive/2011-02/msg00692.html
// sts graph , by(rec_vs_none) ci risktable censored(number) ci1opts(fcolor(navy%20)) ci2opts(fcolor(maroon%20))