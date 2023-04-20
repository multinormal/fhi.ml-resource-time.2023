version 16.1

global data_file  "data/raw/Final data sheet_31012023_jm.xlsx"
global sheet_name "Data Extraction Form"
global cellrange  A1:BE40
global signature           "39:57(80915):1037905700:239166213" // Signature of raw data.
global processed_signature "39:13(85310):351721399:2468083089" // Signature of processed data.

global exported_data_file "products/resource-time.dta"

global random_seed 1234

global p_threshold 0.0001

global report_filename "products/ml-resource-time-report.docx"

// Define the comparisons specified in the protocol published in the journal.
global comparisons rec_vs_none rec_vs_nonrec any_vs_none 

// Define the outcomes.
global outcomes resource time

// Define the outcome variables.
global resource_outcome log_resource1 log_resource2
// Note: No need to specify outcomes for stset data.

// Define fixed effect covariate.
global adj_var i.meta_analysis_planned

// Specify the model for endogeneous treatment assignment.
global endo_vars i.field i.prespecified
