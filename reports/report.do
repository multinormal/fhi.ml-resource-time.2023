version 16.1

// Some locals to make this file a little more readable.
local heading putdocx paragraph, style(Heading1)
local subhead putdocx paragraph, style(Heading2)
local newpara putdocx textblock begin, halign(both)
local putdocx textblock end putdocx textblock end

local p_fmt  %5.2f // Format used for P-values.
local e_fmt  %5.2f // Format used for estimates.
local pc_fmt %8.1f // Format used for percentages.

local tbl_num = 0  // A table counter.

// Start the document.
putdocx begin

// Title.
putdocx paragraph, style(Title)
putdocx text ("TODO: Trial Name")

// Author and revision information.
`newpara'
TODO: Name and institution
(<<dd_docx_display: c(current_date)>>)
putdocx textblock end
`newpara'
Generated using git revision: <<dd_docx_display: "${git_revision}">>
putdocx textblock end

// Introduction section.
`heading'
putdocx text ("Introduction")

`newpara'
This document presents methods and results for the TODO trial.
putdocx textblock end

// Methods section
`heading'
putdocx text ("Methods")

`newpara'
TODO: Write methods text.
putdocx textblock end

// Results section
`heading'
putdocx text ("Results")

`newpara'
TODO: Add results.
putdocx textblock end

// References
`heading'
putdocx text ("References")

`newpara'
TODO: Add references.
putdocx textblock end

// Appendices

`heading'
putdocx text ("Appendix 1 — Protocol Deviations")

`newpara'
TODO: Describe any protocol deviations.
putdocx textblock end

`heading'
putdocx text ("Appendix 2 — Full Regression Results")

`newpara'
TODO: Present full regression tables.
putdocx textblock end

// Save the report to the specified filename.
putdocx save "${report_filename}", replace
