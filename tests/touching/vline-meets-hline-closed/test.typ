// The mirror of the above with `meet: 0pt`: the vertical rules run into the
// horizontal one rather than stopping short of it.
#import "/tests/cases.typ": *
#show: setup
#show table: booktabs.with(rule-inset: (x: 6pt, y: 2.7pt, meet: 0pt))


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
