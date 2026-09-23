// An hline can cover part of a row, like booktabs' \cmidrule.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 3,
  align: (left, center, right),
  table.header(..head),
  ..rows.slice(0, 3),
  table.hline(start: 1),
  ..rows.slice(3, 6),
  table.hline(start: 0, end: 2),
  ..rows.slice(6),
)
