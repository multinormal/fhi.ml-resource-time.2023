version 18

// Clear everything and set up logging.
clear all
log close _all
log using products/log.smcl, name("ML noML") replace

// Set up globals.
do globals/globals
do globals/models

// Set up Stata.
do setup/setup

// Import, process the data.
do data/data

// Clear the data and then use the processed data.
clear
do data/use

// Do estimation.
do estimation/estimate

// Make figures
do figures/figures

// Obtain the git revision hash, which is used in the reports.
tempfile git_revision_filename
tempname revision_file
shell git rev-parse --short HEAD > "`git_revision_filename'"
file open `revision_file' using `git_revision_filename', read text
file read `revision_file' line
global git_revision = "`macval(line)'"

// Make the report.
do reports/report
