// A `break-rule` function is handed the column and row the two rules meet at
// and the rules themselves, and names the one to break. Here the horizontal
// rule gives way, but only where it is the light one under the header; the
// heavy rules closing the table keep running through.
#import "/tests/cases.typ": *
#show: setup
#show table: booktabs.with(break-rule: (x, y, hl, vl) => {
  if hl.stroke == 0.5pt { table.hline } else { table.vline }
})

#table(
  columns: 3,
  align: (left, center, right),
  table.vline(x: 1),
  table.header(..head),
  ..rows,
)
