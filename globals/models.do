version 16.1

foreach comparison of global comparisons {
  global `comparison'_resource_model eintreg ${resource_outcome} ${adj_var} , entreat(`comparison' = ${endo_vars} , nointeract)
  global `comparison'_time_model     stteffects ipwra (${adj_var}) (`comparison' ${endo_vars}) , aequations
}
