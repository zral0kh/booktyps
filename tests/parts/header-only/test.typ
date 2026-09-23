// Only the header's rule; the body runs to the bottom rule.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 3,
  align: (left, center, right),
  table.header(..head),
  ..rows,
)
