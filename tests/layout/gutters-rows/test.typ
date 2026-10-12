// The author's `row-gutter` is kept the same way. A horizontal rule standing in
// it is centred in it, a vertical rule runs across the gutters where nothing
// stands, and a gutter beside the header and the footer is the author's too.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 3, row-gutter: (3pt, 10pt),
  table.vline(x: 1),
  table.header(..head),
  ..rows,
  table.footer(..foot),
)
