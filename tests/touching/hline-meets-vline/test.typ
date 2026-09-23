// A horizontal rule that stops exactly at a vertical one only touches it, so
// neither gives way, however thick the vertical rule is. The first rule starts
// at the vertical one and the second ends at it; both stay whole, and the
// vertical rule runs past both without a break.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 4,
  align: center,
  table.vline(x: 2, stroke: 0.9pt),
  [a], [b], [c], [d],
  table.hline(start: 2),
  [a], [b], [c], [d],
  table.hline(end: 2),
  [a], [b], [c], [d],
)
