// A span is stretched over the blank tracks the rules add inside it. A rowspan
// crossing an hline keeps the rule out of its column, a colspan crossing a vline
// swallows the vline, a header may hold a spanning cell, and a cell given its
// own `x` and `y` does not disturb where the next one goes.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 3,
  table.vline(x: 1),
  table.header(table.cell(rowspan: 2)[W], table.cell(colspan: 2)[Date], [a], [b]),
  table.cell(rowspan: 3)[1], [Mon], [x],
  [Wed], [y],
  table.hline(start: 1),
  [Fri], [z],
  table.cell(colspan: 2)[Wide, over the vline], [q],
  table.cell(x: 2, y: 6)[Pinned],
)
