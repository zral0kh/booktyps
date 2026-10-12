// A cell that spans a gutter spans it whole, whether it is a gutter of Typst's
// or the room beside a rule: one cell, so it is painted across it, as a cell of
// Typst's own is across a gutter in the middle of it. The rules run up to it and
// stop at it as at any other spanning cell. The spans are filled as cells; a
// fill for the whole table stops at a gutter in each row it covers, the thin
// strips of air above and below a rule included, which a span beside them
// would show.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 3, column-gutter: 12pt, row-gutter: (3pt, 9pt),
  table.vline(x: 2),
  table.header(table.cell(colspan: 2, fill: luma(220))[*Wide*], [*C*]),
  table.cell(rowspan: 2, fill: luma(232))[tall], [a], [b],
  [c], [d],
  table.hline(start: 1),
  table.cell(colspan: 3, fill: luma(220))[the whole width],
)
