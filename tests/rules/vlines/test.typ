// Every vertical rule stops short of every horizontal one: at the top rule,
// at the header's and the footer's, at an hline the author placed, and at the
// bottom rule. A vline may also cover only part of the table.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 3,
  align: (left, center, right),
  table.vline(x: 1),
  table.vline(x: 2, start: 1, end: 3),
  table.header(..head),
  ..rows.slice(0, 3),
  table.hline(),
  ..rows.slice(3),
  table.footer(..foot),
)
