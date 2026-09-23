// Several rules may sit on one boundary, which is booktabs setting two
// `\cmidrule`s on the same vertical alignment. Both must be drawn, and they
// share the one band of air rather than each claiming their own, so the rows
// stay at the pitch a single rule would give them.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 4,
  align: center,
  table.header([*A*], [*B*], [*C*], [*D*]),
  [a], [b], [c], [d],
  // Left apart, so that both are plainly there and not one rule spanning both.
  table.hline(y: 2, start: 0, end: 1),
  [#table.hline(y: 2, start: 3, end: 4)<steals-space>],
  [a], [b], [c], [d],
  // An authored rule joins the structural one instead of replacing it.
  table.hline(y: 3, start: 1, end: 3, stroke: 0.9pt),
  [a], [b], [c], [d],
)
