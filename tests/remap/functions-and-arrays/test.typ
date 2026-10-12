// `fill`, `align` and `inset` are written against the table as the author sees
// it, but the grid built here has blank tracks in it. They are asked about the
// authored cell, so the red row is the second authored row, the right-aligned
// column is the third even though a thick vline makes the hlines break and
// adds columns, and a column's fill runs through the gap a rule leaves.
#import "/tests/cases.typ": *
#show: setup

#let cells = ([Name], [Qty], [Price], [x], [12], [3.50], [yy], [7], [10.00])

// Blank rows only: fill by function, on authored coordinates.
#table(
  columns: 3,
  fill: (x, y) => if x == 1 { luma(220) } else if y == 1 { rgb("#fdd") },
  table.vline(x: 1),
  table.hline(y: 2),
  ..cells,
)

// Blank columns too: an array for fill and for align, both cycling by column.
#table(
  columns: 3,
  align: (left, center, right),
  fill: (white, luma(220)),
  table.vline(x: 1, stroke: 1.5pt),
  table.hline(y: 2),
  ..cells,
)

// An inset function.
#table(
  columns: 3,
  inset: (x, y) => (left: if x == 0 { 18pt } else { 6pt }, rest: 2.7pt),
  table.vline(x: 1, stroke: 1.5pt),
  table.hline(y: 2),
  ..cells,
)
