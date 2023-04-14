version 16.1

foreach comparison of global comparisons {
  global `comparison'_resource_model eintreg ${resource_outcome} ${adj_var} , entreat(`comparison' = ${endo_vars} , nointeract)
  global `comparison'_time_model     stteffects ipwra (${adj_var}) (`comparison' ${endo_vars}) , aequations
}

// Override the following analysis because there is no clear evidence of endogenicity for treatment assignment
// for field or prespecification, except on the basis of an exploratory logistic regression that suggests that
// field may predict treatment assignment.
global rec_vs_nonrec_resource_model intreg ${resource_outcome} i.rec_vs_nonrec ${adj_var}

// Override the following analysis because the variable prespecified does not vary if rec_vs_none is H // TODO: Change H to treatment assignment.
// TODO: Document this.
global rec_vs_none_resource_model eintreg ${resource_outcome} ${adj_var} , entreat(rec_vs_none = i.field , nointeract)
