// The author's `column-gutter` is kept. Where nothing stands in it, it is a
// gutter of Typst's, with the rules running across it unbroken, where cell
// strokes would have stopped at every one; an array repeats its last size as it
// does for a table without rules. A vertical rule standing in a gutter is
// centred in it, and the gutter is as wide as it was with none. The left of each
// pair is a table of Typst's own with the rules laid by hand, which is what the
// right one is to look like.
#import "/tests/cases.typ": *
#show: setup
#set table(fill: (x, y) => if calc.odd(x) { luma(228) })

#let cells = ([A], [B], [C], [1], [2], [3])
#let pair(gutter, vline: false, ..options) = grid(
  columns: (1fr, 1fr), column-gutter: 6mm,
  table(
    columns: 3, column-gutter: gutter, stroke: none,
    table.hline(y: 0, stroke: 0.9pt), table.hline(y: 1, stroke: 0.5pt),
    table.hline(y: 2, stroke: 0.9pt),
    ..if vline { (table.vline(x: 1, stroke: 0.4pt),) },
    ..cells,
  ),
  [
    #show table: booktyps.booktabs.with(
      heavy: 0.9pt, light: 0.5pt, vertical: 0.4pt, rule-inset: 2.7pt, ..options,
    )
    #table(
      columns: 3, column-gutter: gutter,
      table.header(..cells.slice(0, 3)), ..cells.slice(3),
      ..if vline { (table.vline(x: 1),) },
    )
  ],
)

#pair(14pt)
#v(3mm)
#pair((4pt, 24pt))
#v(3mm)
#pair(14pt, vline: true)
#v(3mm)
// The air of the rule is added to the gutter, as it is to the padding.
#pair(14pt, vline: true, vertical-space: true)
