// With `meet: 0pt` the edge rules close the table into a box, since nothing
// stops short at a corner any more. The crossed rule still gives way.
#import "/tests/cases.typ": *
#show: setup
#show table: booktabs.with(rule-inset: (x: 6pt, y: 2.7pt, meet: 0pt))


#table(
  columns: 3,
  align: (left, center, right),
  table.vline(x: 0, stroke: 0.9pt),
  table.vline(x: 1, stroke: 0.9pt),
  table.vline(x: 3, stroke: 0.9pt),
  table.header(..head),
  ..rows,
)
