// Spans among rules that take their gap out of the cells' padding. A span gives
// from the edge it ends at, not the one it starts at, so a rowspan crossing a
// rule gives nothing there and the cells it spans give for it; the same holds
// across a vertical rule for a colspan. The fill is asked in the author's
// coordinates, and a span is filled as the one cell it is.
#import "/tests/cases.typ": *
#show: setup
#show table: booktyps.booktabs.with(
  heavy: 0.9pt, light: 0.5pt, vertical: 0.4pt, rule-inset: 2.7pt,
  rule-steals-space: true, vertical-space: true,
)

#table(
  columns: 4,
  fill: (x, y) => if y == 0 { luma(225) } else if x == 0 and y > 0 { rgb("#eef") },
  table.vline(x: 1),
  table.vline(x: 3, stroke: 1.2pt),
  table.header([*Group*], [*A*], [*B*], [*C*]),
  table.cell(rowspan: 3)[One], [a1], [b1], [c1],
  [a2], [b2], [c2],
  table.hline(start: 1),
  [a3], [b3], [c3],
  table.cell(rowspan: 2)[Two], table.cell(colspan: 2)[wide, over the vertical rule], [c4],
  [a5], [b5], [c5],
)
