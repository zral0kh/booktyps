// A rule standing in a gutter meets the others in it. A horizontal rule that a
// vertical one cuts runs across its half of the gutter and stops short of the
// vertical one by the air that rules keep, and where it only runs up to it, it
// stops short by `meet`, none of it, here, so that the two are joined. The gutter
// does not change which rule gives way, only how much lies between.
#import "/tests/cases.typ": *
#show: setup

#let cells = ([A], [B], [C], [1], [2], [3], [x], [y], [z])

// A thick vertical rule, cut across by a horizontal one that gives way.
#table(
  columns: 3, column-gutter: 14pt,
  table.vline(x: 1, stroke: 1.2pt), table.hline(y: 1),
  ..cells,
)

#v(3mm)

// The same, the horizontal one only running up to the vertical one, closed.
#show table: booktyps.booktabs.with(
  heavy: 0.9pt, light: 0.5pt, vertical: 0.4pt,
  rule-inset: (x: 6pt, y: 2.7pt, meet: 0pt),
)
#table(
  columns: 3, column-gutter: 14pt,
  table.vline(x: 1), table.hline(y: 1, end: 1),
  ..cells,
)
