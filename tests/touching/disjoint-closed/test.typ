// `meet` takes a dictionary of its own, so a meeting can stop short by a
// different amount across than along. The horizontal rule still neither meets
// nor crosses the vertical one and is unaffected, but the vertical rule runs
// the whole height and so meets the heavy rules closing the table: it stops
// short of those by the 1pt given here rather than by the full 2.7pt.
#import "/tests/cases.typ": *
#show: setup
#show table: booktabs.with(rule-inset: (x: 6pt, y: 2.7pt, meet: (x: 6pt, y: 1pt)))


#table(
  columns: 4,
  align: center,
  table.vline(x: 1),
  table.hline(y: 2, start: 2, stroke: 0.9pt),
  [a], [b], [c], [d],
  [a], [b], [c], [d],
  [a], [b], [c], [d],
)
