version 16.1

foreach comparison of global comparisons {
  global `comparison'_resource_model eintreg ${resource_outcome} ${adj_var} , entreat(`comparison' = ${endo_vars} , nointeract)
  global `comparison'_time_model     stteffects ipwra (${adj_var}) (`comparison' ${endo_vars}) , aequations
}

// TODO: Temporarily overriding this model as no evidence of endogenicity for treatment assignment for this comparison.
// TODO: Update methods text if we keep this model.
global rec_vs_nonrec_resource_model intreg ${resource_outcome} i.rec_vs_nonrec ${adj_var}
