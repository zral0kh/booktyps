// A rule on the table's own edge has nothing running past it. The vertical
// rules span every row, so they only touch the heavy rules closing the table,
// which stay whole; the light rule under the header is crossed and gives way.
// The outermost vertical rules sit on the table's left and right edges, where
// they cross nothing at all.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 3,
  align: (left, center, right),
  table.vline(x: 0, stroke: 0.9pt),
  table.vline(x: 1, stroke: 0.9pt),
  table.vline(x: 3, stroke: 0.9pt),
  table.header(..head),
  ..rows,
)
