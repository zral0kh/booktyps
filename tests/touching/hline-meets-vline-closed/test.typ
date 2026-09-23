// The same rules with `meet: 0pt`: nothing stops short where two rules only
// touch, so the short rules run into the vertical one and the table is no
// wider for it. Rules that genuinely cross are unaffected.
#import "/tests/cases.typ": *
#show: setup
#show table: booktabs.with(rule-inset: (x: 6pt, y: 2.7pt, meet: 0pt))


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
