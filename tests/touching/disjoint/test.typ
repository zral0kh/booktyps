// Rules that never reach each other leave each other alone. The horizontal
// rule covers the last two columns and the vertical one stands before them, so
// despite being the thinner of the two it keeps running.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 4,
  align: center,
  table.vline(x: 1),
  table.hline(y: 2, start: 2, stroke: 0.9pt),
  [a], [b], [c], [d],
  [a], [b], [c], [d],
  [a], [b], [c], [d],
)
