// The table's own `stroke` is ignored: the rules are the ones read off its
// structure and the ones placed in it, and nothing else is drawn, neither the
// stroke given nor Typst's default grid. A cell's own `stroke` is the author
// speaking about that cell and is left alone.
#import "/tests/cases.typ": *
#show: setup

// A red stroke on every cell, which must not appear.
#set table(stroke: red + 1pt)
#table(
  columns: 3,
  table.header(..head),
  ..rows,
  table.footer(..foot),
)

// A stroke on a single cell, which must.
#table(
  columns: 3,
  table.vline(x: 1),
  table.header(..head),
  table.cell(stroke: blue + 1pt)[Row 1], ..rows.slice(1),
)
