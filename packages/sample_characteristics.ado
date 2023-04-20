version 16.1

program sample_characteristics, nclass
  local note Data are number of reviews and percent of all included reviews.

  tempname results
  local n_cols 7
  putdocx table `results' = (20, `n_cols'), border(all, nil) layout(autofitcontents) note("`note'")

  // Header rows.
  putdocx table `results'(1, 2) = ("None")
  putdocx table `results'(1, 3) = ("Recommended")
  putdocx table `results'(1, 4) = ("Non-recommended")
  putdocx table `results'(1, 5) = ("Recommended")
  putdocx table `results'(1, 6) = ("None")
  putdocx table `results'(1, 7) = ("Any")

  // Numbers of reviews.
  count_reviews , table(`results') row(2) title("Commissioned reviews")

  // Completed reviews.
  count_reviews if completed, table(`results') row(3) title("Completed reviews")

  // Review type.
  putdocx table `results'(4, 1) = ("Review type")
  count_reviews if hta,  table(`results') row(5) title("HTA")
  count_reviews if !hta, table(`results') row(6) title("Non-HTA")

  // Synthesis type planned.
  putdocx table `results'(7, 1) = ("Synthesis type planned")
  local synthesis_planned (synthesis_planned | meta_analysis_planned | nma_planned)
  count_reviews if `synthesis_planned',    table(`results') row(8)  title("Any (quantitative or qualitative)")
  count_reviews if meta_analysis_planned,  table(`results') row(9)  title("Pairwise meta-analysis")
  count_reviews if nma_planned,            table(`results') row(10) title("Network meta-analysis")

  // ML functions (identification).
  putdocx table `results'(11, 1) = ("ML used during study identification")
  count_reviews if ranking_identification,     table(`results') row(12)  title("Ranking")
  count_reviews if classifier_identification,  table(`results') row(13)  title("Classifiers")
  count_reviews if clustering_identification,  table(`results') row(14)  title("Clustering")
  count_reviews if openalex_identification,    table(`results') row(15)  title("OpenAlex")

  // ML functions (extraction).
  putdocx table `results'(16, 1) = ("ML used during data extraction")
  count_reviews if classifier_extraction,  table(`results') row(17)  title("Classifiers")
  count_reviews if clustering_extraction,  table(`results') row(18)  title("Clustering")
  count_reviews if automated_extraction,   table(`results') row(19)  title("Automated data extraction")

  // Other ML functions.
  count_reviews if other_ml,               table(`results') row(20)  title("Other ML functions")

  // Format the table.
  putdocx table `results'(1,.), border(top)
  putdocx table `results'(1 4 7 11 16 20,.), border(bottom) border(top)
  putdocx table `results'(., 1 3 5), border(right)
  putdocx table `results'(20,.), border(bottom)
  putdocx table `results'(.,.), font("Calibri (Body)", 8)
  putdocx table `results'(1,.), bold
  putdocx table `results'(1 4 7 11 16 20, 1), bold
  putdocx table `results'(2/3 5/6 8/10 12/15 17/19, 1), halign(right)

end

program count_reviews, nclass
  syntax [if/] , table(string) row(integer) title(string)

  // Insert the row title.
  putdocx table `table'(`row', 1) = ("`title'")

  // Get the total number of reviews.
  count
  local total = r(N)

  // Define predicates for the comparisons.
  local none           rec_vs_none   == 0
  local recommended    rec_vs_none   == 1
  local nonrecommended rec_vs_nonrec == 0
  local recommended    rec_vs_nonrec == 1 // Note the replication.
  local none           any_vs_none   == 0 // Note the replication.
  local any            any_vs_none   == 1

  // Define a list of the predicates.
  local predicates     none recommended nonrecommended recommended none any

  // Make and insert counts for each predicate.
  local num_predicates = wordcount("`predicates'")
  forvalues i = 1/`num_predicates' {
    local predicate : word `i' of `predicates'
    if "`if'" == "" count if ``predicate''
    if "`if'" != "" count if ``predicate'' & `if'
    local count   = r(N)
    local percent = 100 * (r(N) / `total')
    if `count' >= 1 local result : disp `count' " (" %2.0f `percent' "%" ")"
    if `count' == 0 local result : disp `count'
    putdocx table `table'(`row', `=1+`i'') = ("`result'")
  }
end
