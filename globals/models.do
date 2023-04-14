version 16.1

// TODO: Look at the estimates carefully to make sure that directions of effects are computed correctly.
// TODO: Remember that the KM plots may be misleading given the possible endogeneous treatment assignment.

// Specify the time use models.
foreach comparison of global comparisons {
  global `comparison'_time_model     stteffects ipwra (${adj_var}) (`comparison' ${endo_vars}) , aequations
}

// Specify the resource use models. // TODO: Document deviations from protocol.
// TODO: We cannot use both variables to predict treatment in these analyses, and using the wrong one leads to nonsensical results (very large SEs on the treatment predictions).
global rec_vs_none_resource_model   eintreg ${resource_outcome} ${adj_var} , entreat(rec_vs_none   = i.field ,        nointeract)
global rec_vs_nonrec_resource_model eintreg ${resource_outcome} ${adj_var} , entreat(rec_vs_nonrec = i.prespecified , nointeract)
global any_vs_none_resource_model   eintreg ${resource_outcome} ${adj_var} , entreat(any_vs_none   = i.field ,        nointeract)

// TODO: In paper, report that it is interesting that field predicts recommended vs none, and any vs none, but prespecified predicts rec vs nonrec.
// TODO: i.e., does prespecication lead to use of recommended ML? We will know after unblinding.
