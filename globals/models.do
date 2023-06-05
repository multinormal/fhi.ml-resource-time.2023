version 16.1

// Specify the time use models.
foreach comparison of global comparisons {
  global `comparison'_time_model     stteffects ipwra (${adj_var}) (`comparison' ${endo_vars}) , aequations
}

// Specify the resource use models.
// We cannot use both variables to predict treatment in these analyses, and using the wrong one leads to nonsensical results (very large SEs on the treatment predictions).
global rec_vs_none_resource_model   eintreg ${resource_outcome} ${adj_var} , entreat(rec_vs_none   = i.field ,        nointeract)
global rec_vs_nonrec_resource_model eintreg ${resource_outcome} ${adj_var} , entreat(rec_vs_nonrec = i.prespecified , nointeract)
global any_vs_none_resource_model   eintreg ${resource_outcome} ${adj_var} , entreat(any_vs_none   = i.field ,        nointeract)
