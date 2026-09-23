// An hline the author places is drawn like a midrule, wherever it falls.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 3,
  align: (left, center, right),
  table.header(..head),
  ..rows.slice(0, 3),
  table.hline(),
  ..rows.slice(3),
)
