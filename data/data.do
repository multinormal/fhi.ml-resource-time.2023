version 18

// Only import and process the data if necessary.
if fileexists("${exported_data_file}") {
  disp "{hline}"
  disp as result "Using existing processed data"
  exit
}

// Load the data and check its signature is as expected.
import excel "${data_file}", sheet("${sheet_name}") cellrange(${cellrange}) firstrow allstring
datasignature
assert r(datasignature) == "${signature}"

// Define a variable that specifies the product's year.
tempvar year
rename Year `year'
destring `year', generate(year)

// Rename and encode the health/welfare variable.
tempvar field
rename AreaHealthorWelfare `field'
replace `field' = "Healthcare" if `field' == "H"
replace `field' = "Welfare"    if `field' == "W"
encode `field' , generate(field)

// Rename and encode the variable that codes for the type of product.
tempvar product_type
rename Typeofproduct `product_type'
encode `product_type', generate(product_type)

// Rename and encode the variable that codes for whether product is an update.
tempvar update
rename UpdateYN `update'
replace `update' = strtrim(`update')
encode `update', generate(update)

// Define treatment variables.
// Treatment variables will contain valid missing values, e.g. for recommended vs none where some reviews used non-recommended ML.
// We define "intervention" (i.e., the type of ML use we would prefer reviewers to use) as 1, and "control" as 0.
generate          rec_vs_none = .
replace           rec_vs_none = 0 if RecommendedvsNone == "H" // None
replace           rec_vs_none = 1 if RecommendedvsNone == "G" // Recommended
label    define   rec_vs_none 0 "None" 1 "Recommended"
label    values   rec_vs_none rec_vs_none

generate          rec_vs_nonrec = .
replace           rec_vs_nonrec = 0 if RecommendedvsNonrecom == "K" // Non-recommended
replace           rec_vs_nonrec = 1 if RecommendedvsNonrecom == "J" // Recommended
label    define   rec_vs_nonrec 0 "Non-recommended" 1 "Recommended"
label    values   rec_vs_nonrec rec_vs_nonrec

generate          any_vs_none = .
replace           any_vs_none = 0 if AnyvsNone == "R" // None
replace           any_vs_none = 1 if AnyvsNone == "Q" // Any
label    define   any_vs_none 0 "None" 1 "Any"
label    values   any_vs_none any_vs_none

generate          rec_vs_under = .
replace           rec_vs_under = 0 if Recomvsunderuse == "U" // Under-use
replace           rec_vs_under = 1 if Recomvsunderuse == "T" // Recommended
label    define   rec_vs_under 0 "Under-use" 1 "Recommended"
label    values   rec_vs_under rec_vs_under

generate          rec_vs_over = .
replace           rec_vs_over = 0 if Recomvsoveruse == "E" // Over-use
replace           rec_vs_over = 1 if Recomvsoveruse == "D" // Recommended
label    define   rec_vs_over 0 "Over-use" 1 "Recommended"
label    values   rec_vs_over rec_vs_over

// Define the variable labels for the comparisons.
label variable rec_vs_none   "Recommended vs No ML Use"
label variable rec_vs_nonrec "Recommended vs Non-recommended ML Use"
label variable any_vs_none   "Any vs No ML Use"
// Note: We do not use the other comparisons, so will not rename them.

// Define a value label for analyses that can be prespecified.
label define no_yes_label 0 No 1 Yes

// Define variables that code for prespecified synthesis (any), meta-analysis (incl.
// quantitative and qualitative), NMA, etc.
local vars        SynthesisplannednoneYorN SynthesisplannedMetaAnalysis SynthesisplannedNMAYorN
local vars `vars' Rankingalgorithmduringstudyi Classifiersduringstudyidenti Classifiersduringdataextracti
local vars `vars' Clusteringduringstudyidentifi Clusteringduringdataextractio OpenAlexduringstudyidentifica
local vars `vars' RoBassessmentYorN AutomateddataextractionYor OtherMLYorN
local ProtocolavailableYorN           prespecified              // New variable name.
local SynthesisplannednoneYorN        synthesis_planned         // New variable name.
local SynthesisplannedMetaAnalysis    meta_analysis_planned     // New variable name.
local SynthesisplannedNMAYorN         nma_planned               // New variable name.
local Rankingalgorithmduringstudyi    ranking_identification    // New variable name.
local Classifiersduringstudyidenti    classifier_identification // New variable name.
local Classifiersduringdataextracti   classifier_extraction     // New variable name.
local Clusteringduringstudyidentifi   clustering_identification // New variable name.
local Clusteringduringdataextractio   clustering_extraction     // New variable name.
local OpenAlexduringstudyidentifica   openalex_identification   // New variable name.
local RoBassessmentYorN               rob_assessment            // New variable name.
local AutomateddataextractionYor      automated_extraction      // New variable name.
local OtherMLYorN                     other_ml                  // New variable name.
local synthesis_planned_label         "Was any synthesis planned?"
local meta_analysis_planned_label     "Was meta-analysis planned?"
local nma_planned_label               "Was NMA planned?"
local ranking_identification_label    "Ranking algorithm during study identification"
local classifier_identification_label "Classifiers during study identification"
local classifier_extraction_label     "Classifiers during data extraction"
local clustering_identification_label "Clustering during study identification"
local clustering_extraction_label     "Clustering during data extraction"
local openalex_identification_label   "OpenAlex during study identification"
local rob_assessment_label            "ML for RoB assessment"
local automated_extraction            "Automated data extraction"
local other_ml_label                  "Other ML"

foreach p of local vars {
  generate       ``p'' = 0
  replace        ``p'' = 1 if `p' != "N" // Works for one value coded "Both".
  label values   ``p'' no_yes_label
  label variable ``p'' "```p''_label'"
  drop `p'
}

// Define the HTA variable.
generate hta = 0
replace  hta = 1 if HTAYorN == "Y"
label values   hta no_yes_label
label variable hta "Health technology assessment?"

// Define the prespecified variable (whether a protocol was published).
generate prespecified = 0
replace  prespecified = 1 if regexm(ProtocolLink, "http.*")
label values   prespecified no_yes_label
label variable prespecified "Was the work pre-specified?"
drop ProtocolLink

// Define a completed variable (analogous to a failure indicator in survival analysis).
generate          completed = 1
replace           completed = 0 if OngoingYorN == "Y"
label    define   completed 0 No 1 Yes
label    values   completed completed
label    variable completed "Report completed?"
drop OngoingYorN

// Define the resource use variable.
tempvar resource
rename ResourceUsePersonHours `resource'
destring `resource', replace force // One missing outcome.
generate log_resource1 = log(`resource')
generate log_resource2 = log(`resource')
replace  log_resource2 = . if !completed // For right-censored data.
label variable log_resource1 "Lower-bound on resource use (log person-hours)"
label variable log_resource2 "Upper-bound on resource use (log person-hours); possibly censored"

// Define commission date variable.
tempvar c_day c_month c_year commission
rename CommissionDay131   `c_day'
rename CommissionMonth112 `c_month'
rename CommissionYear2020 `c_year'
generate `commission' = `c_day' + "/" + `c_month' + "/" + `c_year'
generate commission = date(`commission', "DMY")
label variable commission "Commission date"

// Define completion date variable.
tempvar c_day c_month c_year completion
rename CompletionDay131   `c_day'
rename CompletionMonth112 `c_month'
rename CompletionYear2020 `c_year'
generate `completion' = `c_day' + "/" + `c_month' + "/" + `c_year'
generate completion = date(`completion', "DMY")
// Set right-censoring date for ongoing reviews.
replace completion = date("31/01/2023", "DMY") if missing(completion) // Date at end of data extraction.
label variable completion "Completion date (possibly censored)"

// We do not have data on number of downloads or commissioner satisfaction.
drop Commissionersatisfactionoveral Numberofdownloadstodate

// Ensure that there are no NMAs in the sample.
levelsof nma_planned
assert r(r) == 1 // Multiple levels would indicate ≥1 NMA.

// Keep just the variables necessary for analysis.
local to_keep completion completed commission ${resource_outcome} *_vs_* prespecified ${adj_var} ${endo_vars}
local to_keep `to_keep' hta nma_planned synthesis_planned *_identification *_extraction rob_assessment other_ml
local to_keep = subinstr("`to_keep'", "i.", "", .)
keep `to_keep'
save ${exported_data_file}, replace
