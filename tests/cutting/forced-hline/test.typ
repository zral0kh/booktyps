// `break-rule: table.hline` breaks the horizontal rules at every crossing, so
// the vertical one runs through even where it is the thinner of the two.
#import "/tests/cases.typ": *
#show: setup
#show table: booktabs.with(break-rule: table.hline)

#table(
  columns: 3,
  align: (left, center, right),
  table.vline(x: 1),
  table.header(..head),
  ..rows,
)
