// `break-rule: table.vline` breaks the vertical rule at every crossing, even
// where it is thicker than the horizontal rule it meets. This is the booktabs
// look, and what the structural rules give by default.
#import "/tests/cases.typ": *
#show: setup
#show table: booktabs.with(break-rule: table.vline)

#table(
  columns: 4,
  align: (left, center, center, center),
  table.vline(x: 1, stroke: 0.9pt),
  table.hline(y: 1, stroke: 0.4pt),
  table.hline(y: 2, stroke: 0.4pt),
  [*Language*], [Typst], [TeX], [Lout],
  [*Year*], [2019], [1978], [1991],
  [*Typed*], [yes], [no], [no],
)
