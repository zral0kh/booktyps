// Only the footer's rule; the body starts at the top rule.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 3,
  align: (left, center, right),
  ..rows,
  table.footer(..foot),
)
