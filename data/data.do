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

// Define the resource use variable.
// TODO: Do we need to log-transform to estimate *relative* resource use?
rename ResourceUsePersonHours resource_use
destring resource_use, replace force

// Define a completed variable (analogous to a failure indicator in survival analysis).
generate          completed = 1
replace           completed = 0 if OngoingYorN == "N"
label    define   completed 0 No 1 Yes
label    values   completed completed
label    variable completed "Report completed?"
drop OngoingYorN
