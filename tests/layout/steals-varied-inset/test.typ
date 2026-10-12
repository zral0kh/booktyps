// A rule that steals its gap takes it from what the cells beside it have, and
// what they have is not always one number for the whole table: an inset may be
// a function of the cell, may name `rest`, may be in `em`, or a cell may carry
// an inset of its own. None of these may crash or push a cell's padding below
// nothing; a row gives only what its tightest cell can spare.
#import "/tests/cases.typ": *
#show: setup
#show table: booktyps.booktabs.with(
  heavy: 0.9pt, light: 0.5pt, vertical: 0.4pt, rule-inset: 2.7pt,
  rule-steals-space: true,
)
// A function of the cell: the first column is padded more than the rest, and
// `rest` is the padding above and below, which the function is the one place to
// give as `rest` alone, a table's own inset being folded with the `set` rule's.
#table(
  columns: 3,
  inset: (x, y) => (left: if x == 0 { 14pt } else { 6pt }, right: 6pt, rest: 4pt),
  table.header(..head),
  ..rows.slice(0, 3),
  table.hline(),
  ..rows.slice(3),
)

// `rest` and `em`.
#table(
  columns: 3,
  inset: (x: 0.6em, rest: 0.3em),
  table.header(..head),
  ..rows.slice(0, 3),
  table.hline(),
  ..rows.slice(3),
)

// One cell with less padding than the rule would take: the row cannot give
// more than that cell has, so the rest of the gap is added instead.
#table(
  columns: 3,
  inset: 6pt,
  table.header(..head),
  [Row 1], table.cell(inset: 0.5pt)[Tight], [42.0],
  table.hline(),
  ..rows.slice(3),
)
