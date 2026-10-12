// A vertical rule that nothing stops short of sits against the cells beside it
// and costs no width. With `vertical-space` it keeps `rule-inset` air on
// both sides, as a horizontal rule does, so a plain vline and one that another
// rule breaks at leave the same gap. The fill shows where the cells end.
#import "/tests/cases.typ": *
#show: setup
#set table(fill: (x, y) => if x == 1 { luma(220) })

#let sample() = table(
  columns: 3,
  table.vline(x: 1),
  table.vline(x: 2, stroke: 1.2pt),
  table.header(..head),
  ..rows,
  table.footer(..foot),
)

#sample()
#[
  #show table: booktabs.with(vertical-space: true)
  #sample()
]
#[
  #show table: booktabs.with(vertical-space: true, rule-steals-space: true)
  #sample()
]
