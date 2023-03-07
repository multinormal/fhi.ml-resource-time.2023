version 16.1

global data_file  "data/raw/Blinded data sheet_060323 - Downloaded 07-03-2023.xlsx"
global sheet_name "Data Extraction Form"
global cellrange  A1:AC40
global signature "39:29(69325):2253827172:810722692"

global random_seed 1234

global p_threshold 0.0001

global report_filename "products/ml-resource-time-report.docx"

// Define the comparisons specified in the protocol published in the journal.
global comparisons rec_vs_none rec_vs_nonrec any_vs_none 
// TODO: Report that we are dropping recommended versus over- underuse comparisons
// TODO: (i.e., those specified in the revised preprint), as only 2 observations in one of the groups for each of these.

// Define the outcomes.
global outcomes resource time

// Define the outcome variables.
global resource_outcome log_resource1 log_resource2 // TODO: Change to non-log!
// Note: No need to specify outcomes for stset data.

// Define fixed effect covariate.
global adj_var i.meta_analysis_planned

// Specify the model for endogeneous treatment assignment.
global endo_vars i.field i.prespecified // TODO: Check for evidence of endogenicity for these variables.
