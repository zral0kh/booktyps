// A header and a footer each get a light rule on the inward side.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 3,
  align: (left, center, right),
  table.header(..head),
  ..rows,
  table.footer(..foot),
)
