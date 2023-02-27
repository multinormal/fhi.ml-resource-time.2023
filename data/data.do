version 16.1

// Load the data and check its signature is as expected.
import excel "${data_file}", sheet("${sheet_name}") cellrange(${cellrange}) firstrow allstring
datasignature
assert r(datasignature) == "${signature}"

// Rename the health/welfare variable and use value labels.
tempvar field
rename AreaHealthorWelfare `field'
replace `field' = "Healthcare" if `field' == "H"
replace `field' = "Welface"    if `field' == "W"
encode `field' , generate(field)

