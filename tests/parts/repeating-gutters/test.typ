// A header and a footer that repeat carry the rules inside them and the room
// beside those rules, so each page has them whole, and the gutters between the
// columns are the same on every page.
#import "/tests/cases.typ": *
#show: setup
#set page(height: 4.6cm)

#table(
  columns: 3, column-gutter: (6pt, 14pt), row-gutter: 2pt,
  table.vline(x: 1),
  table.header(repeat: true, ..head),
  ..range(18).map(i => [Row #(i + 1)]),
  table.hline(y: 4, start: 1),
  table.footer(repeat: true, ..foot),
)
