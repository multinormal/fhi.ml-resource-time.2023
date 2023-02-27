version 16.1

// Load the data and check its signature is as expected.
if "${data_file}" == "data/raw/TODO" exit // TODO: REMOVE THIS LINE
use "${data_file}", replace
datasignature
assert r(datasignature) == "${signature}"
