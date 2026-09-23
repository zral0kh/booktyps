// Where the air around a rule comes from.
//
// A rule needs a gap either side of it, and that gap has to come from
// somewhere. By default it is added, so rules push the rows apart. Told to
// steal, a rule takes the gap out of the padding of the cells beside it
// instead, and the table keeps the height it had with no rules at all. Where
// the padding cannot cover the gap, only the shortfall is added.

#import "/lib.typ": booktabs

#set page(width: 13cm, height: auto, margin: 8mm)
#set text(font: "Libertinus Serif", size: 10pt)
#set table(inset: (x: 6pt, y: 4pt))

#let schedule(..bind) = [
  #show table: booktabs.with(..bind)
  #table(
    columns: 3,
    align: (left, left, right),
    table.header([*Session*], [*Room*], [*Start*]),
    [Registration], [Foyer], [08:30],
    [Keynote], [Auditorium], [09:00],
    table.hline(),
    [Track A], [Hall 1], [10:30],
    [Track B], [Hall 2], [10:30],
    table.hline(),
    [Close], [Auditorium], [16:00],
  )
]

#grid(
  columns: (1fr, 1fr),
  column-gutter: 8mm,
  [
    #text(size: 8pt, fill: luma(40%))[adding the gap (the default)]
    #schedule()
  ],
  [
    #text(size: 8pt, fill: luma(40%))[taking it from the cells]
    // The rows sit where they would with no rules at all, so the two tables
    // differ only by the height the rules would otherwise have added.
    #schedule(rule-steals-space: true)
  ],
)

#v(4mm)
#text(size: 8pt, fill: luma(40%))[one rule marked, the rest left alone]

// A label on a rule settles it for that rule only, whichever way the table is
// set. Write it by attaching the label inside a content block.
#[
  #show table: booktabs.with(rule-steals-space: false)
  #table(
    columns: 3,
    align: (left, left, right),
    table.header([*Session*], [*Room*], [*Start*]),
    [Registration], [Foyer], [08:30],
    [Keynote], [Auditorium], [09:00],
    [#table.hline()<steals-space>],
    [Track A], [Hall 1], [10:30],
    [Track B], [Hall 2], [10:30],
    table.hline(),
    [Close], [Auditorium], [16:00],
  )
]
