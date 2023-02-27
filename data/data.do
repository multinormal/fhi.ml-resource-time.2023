version 16.1

// Load the data and check its signature is as expected.
import excel "${data_file}", sheet("${sheet_name}") cellrange(${cellrange}) firstrow allstring
datasignature
assert r(datasignature) == "${signature}"

// Rename and encode the health/welfare variable.
tempvar field
rename AreaHealthorWelfare `field'
replace `field' = "Healthcare" if `field' == "H"
replace `field' = "Welface"    if `field' == "W"
encode `field' , generate(field)

// Rename the variable that specifies whether any synthesis was prespecified.
generate          prespecified = 0
replace           prespecified = 1 if SynthesisplannednoneYorN == "Y"
label    define   prespecified 0 No 1 Yes
label    values   prespecified prespecified
label    variable prespecified "Was any synthesis prespecified?"
drop SynthesisplannednoneYorN

// Define treatment variables.
// TODO: Treatment variables will contain valid missing values, e.g. for recommended vs none where some reviews used non-recomended ML.
local treatments RecommendedvsNone RecommendedvsNonrecom AnyvsNone Recomvsunderuse Recomvsoveruse
local RecommendedvsNone     rec_vs_none   // New variable name.
local RecommendedvsNonrecom rec_vs_nonrec // New variable name.
local AnyvsNone             any_vs_none   // New variable name.
local Recomvsunderuse       rec_vs_under  // New variable name.
local Recomvsoveruse        rec_vs_over   // New variable name.
foreach t of local treatments {
  replace `t' = "" if !regexm(`t', "[A-Z]") // Non-missing values are letters in [A-Z]
  encode  `t', generate(``t'')
  drop `t'
}

// Define the resource use variable.
// TODO: Do we need to log-transform to estimate *relative* resource use?
rename ResourceUsePersonHours resource_use
destring resource_use, replace force

// Define a completed variable (analogous to a failure indicator in survival analysis).
generate          completed = 1
replace           completed = 0 if OngoingYorN == "Y"
label    define   completed 0 No 1 Yes
label    values   completed completed
label    variable completed "Report completed?"
drop OngoingYorN

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
tempvar max
egen `max' = max(completion)
replace completion = `max' if missing(completion)

// stset the data.
stset completion , failure(completed) origin(time commission) scale(7 /*days*/)

