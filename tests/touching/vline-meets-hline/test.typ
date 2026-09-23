// The same the other way round. The first vertical rule ends where the thick
// horizontal rule is and the second begins there, so neither crosses it and
// the horizontal rule stays whole across the full width.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 4,
  align: center,
  table.hline(y: 2, stroke: 0.9pt),
  table.vline(x: 1, end: 2),
  table.vline(x: 3, start: 2),
  [a], [b], [c], [d],
  [a], [b], [c], [d],
  [a], [b], [c], [d],
  [a], [b], [c], [d],
)
