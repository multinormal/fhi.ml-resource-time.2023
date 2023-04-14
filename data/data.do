version 16.1

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

// Rename and encode the variable that codes for whether product is an HTA.
tempvar hta
rename HTAYorN `hta'
encode `hta', generate(hta)

// Define treatment variables.
// Treatment variables will contain valid missing values, e.g. for recommended vs none where some reviews used non-recommended ML.
generate          rec_vs_none = .
replace           rec_vs_none = 0 if RecommendedvsNone == "H"
replace           rec_vs_none = 1 if RecommendedvsNone == "G"
label    define   rec_vs_none 0 "H" 1 "G"
label    values   rec_vs_none rec_vs_none

generate          rec_vs_nonrec = .
replace           rec_vs_nonrec = 0 if RecommendedvsNonrecom == "J"
replace           rec_vs_nonrec = 1 if RecommendedvsNonrecom == "K"
label    define   rec_vs_nonrec 0 "J" 1 "K"
label    values   rec_vs_nonrec rec_vs_nonrec

generate          any_vs_none = .
replace           any_vs_none = 0 if AnyvsNone == "Q"
replace           any_vs_none = 1 if AnyvsNone == "R"
label    define   any_vs_none 0 "Q" 1 "R"
label    values   any_vs_none any_vs_none

generate          rec_vs_under = .
replace           rec_vs_under = 0 if Recomvsunderuse == "T"
replace           rec_vs_under = 1 if Recomvsunderuse == "U"
label    define   rec_vs_under 0 "T" 1 "U"
label    values   rec_vs_under rec_vs_under

generate          rec_vs_over = .
replace           rec_vs_over = 0 if Recomvsoveruse == "D"
replace           rec_vs_over = 1 if Recomvsoveruse == "E"
label    define   rec_vs_over 0 "D" 1 "E"
label    values   rec_vs_over rec_vs_over

// Define the variable labels for the comparisons.
label variable rec_vs_none   "Recommended vs No ML Use"
label variable rec_vs_nonrec "Recommended vs Non-recommended ML Use"
label variable any_vs_none   "Any vs No ML Use"
// Note: We do not use the other comparisons, so will not rename them.

// Define a value label for analyses that can be prespecified.
label define planned 0 No 1 Yes

// Define variables that code for prespecified synthesis (any), meta-analysis (incl.
// quantitative and qualitative), and NMA.
local planned SynthesisplannednoneYorN SynthesisplannedMetaAnalysis SynthesisplannedNMAYorN
local ProtocolavailableYorN        prespecified          // New variable name.
local SynthesisplannednoneYorN     synthesis_planned     // New variable name.
local SynthesisplannedMetaAnalysis meta_analysis_planned // New variable name.
local SynthesisplannedNMAYorN      nma_planned           // New variable name.
local synthesis_planned_label     "Was any synthesis planned?"
local meta_analysis_planned_label "Was meta-analysis planned?"
local nma_planned_label           "Was NMA planned?"

foreach p of local planned {
  generate       ``p'' = 0
  replace        ``p'' = 1 if `p' != "N" // Works for one value coded "Both".
  label values   ``p'' planned
  label variable ``p'' "```p''_label'"
  drop `p'
}

// Define the prespecified variable (whether a protocol was published).
generate prespecified = 0
replace  prespecified = 1 if regexm(ProtocolLink, "http.*")
label values   prespecified planned
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
destring `resource', replace force // One missing outcome. TODO: Note this in the report.
generate log_resource1 = log(`resource')
generate log_resource2 = log(`resource')
replace  log_resource2 = . if !completed // For right-censored data.
label variable log_resource1 "Resource use (log person-hours)"
label variable log_resource2 "Resource use (log person-hours); possibly censored"

// Define commision date variable.
tempvar c_day c_month c_year commission
rename CommissionDay131   `c_day'
rename CommissionMonth112 `c_month'
rename CommissionYear2020 `c_year'
generate `commission' = `c_day' + "/" + `c_month' + "/" + `c_year'
generate commission = date(`commission', "DMY")

// Define completion date variable.
tempvar c_day c_month c_year completion
rename CompletionDay131   `c_day'
rename CompletionMonth112 `c_month'
rename CompletionYear2020 `c_year'
generate `completion' = `c_day' + "/" + `c_month' + "/" + `c_year'
generate completion = date(`completion', "DMY")
// Set right-censoring date for ongoing reviews.
replace completion = date("31/01/2023", "DMY") if missing(completion) // Date at end of data extraction.

// stset the data.
stset completion , failure(completed) origin(time commission) scale(7 /*days*/)

// We do not have data on number of downloads or comissioner satisfaction.
drop Commissionersatisfactionoveral Numberofdownloadstodate

// Ensure that there are no NMAs in the sample.
levelsof nma_planned
assert r(r) == 1 // Multiple levels would indicate ≥1 NMA.

// TODO: Drop other variables with uppercase first letters?
