version 16.1

use ${exported_data_file}
datasignature
assert r(datasignature) == "${processed_signature}"

// stset the data.
stset completion , failure(completed) origin(time commission) scale(7 /*days*/)
