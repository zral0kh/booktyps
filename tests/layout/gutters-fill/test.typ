// A gutter belongs to no cell, so no fill reaches it, whether it is a gutter of
// Typst's or the room that became one beside a rule: the table's one fill, a
// function of the cell, or an array over the columns. A fill that is not to
// reach a gutter is a fill that stops where the cells do.
#import "/tests/cases.typ": *
#show: setup

#let cells = ([A], [B], [C], [1], [2], [3])

#let sample(..options) = table(
  columns: 3, column-gutter: (14pt, 6pt),
  table.vline(x: 1),
  table.header(..cells.slice(0, 3)), ..cells.slice(3),
  ..options,
)

// One fill for the whole table.
#[
  #set table(fill: luma(228))
  #sample()
]
#v(2mm)
// A function of the cell.
#sample(fill: (x, y) => if y == 0 { luma(205) } else if calc.odd(x) { luma(232) })
#v(2mm)
// An array over the columns.
#sample(fill: (luma(205), luma(232)))
