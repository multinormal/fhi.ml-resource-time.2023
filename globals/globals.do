version 16.1

global data_file  "data/raw/Blinded data sheet_310123 - Downloaded 27-02-23.xlsx"
global sheet_name "Data Extraction Form"
global cellrange  A1:AB40
global signature "39:28(17933):3819763061:1092073612"

global random_seed 1234

global report_filename "products/report.docx"

// Define the comparisons.
global comparisons rec_vs_none rec_vs_nonrec

// Define the outcomes.
global outcomes resource time

// Define the outcome variables.
global resource_outcome log_resource1 log_resource2 // TODO: Change to non-log!
// Note: No need to specify outcomes for stset data.

// Define fixed effect covariate.
global adj_var i.meta_analysis_planned

// Specify the model for endogeneous treatment assignment.
// TODO: Check if synthesis_planned corresponds to pre-specification. Waiting on a reply from Jose.
global endo_vars i.field i.synthesis_planned
