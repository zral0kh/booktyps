// `vertical-space` holds every vertical rule away from the cells beside it, and
// the rules at the table's edges close it into a box where `meet` is nothing.
// The vertical rules at the edges have air on the inner side only, and the
// horizontal rules run up to them.
#import "/tests/cases.typ": *
#show: setup
#show table: booktyps.booktabs.with(
  heavy: 0.9pt, light: 0.5pt, vertical: 0.4pt,
  rule-inset: (x: 6pt, y: 2.7pt, meet: 0pt),
  vertical-space: true,
)

#table(
  columns: 3,
  table.vline(x: 0),
  table.vline(x: 1),
  table.vline(x: 3),
  table.header(..head),
  ..rows,
  table.footer(..foot),
)
