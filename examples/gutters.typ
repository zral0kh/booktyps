// Gutters.
//
// `column-gutter` and `row-gutter` work as on any table. The rules run straight
// across them, where a stroke on the cells would stop at every one, and a rule
// that stands in a gutter is centred in it.

#import "/lib.typ": booktabs

#set page(width: 14cm, height: auto, margin: 8mm)
#set text(font: "Libertinus Serif", size: 10pt)
#set table(inset: (x: 5pt, y: 2.7pt))
#show table: booktabs

#let note(body) = text(size: 8pt, fill: luma(40%))[#body]

#let langs = (
  [Typst], [yes], [2019],
  [TeX],   [no],  [1978],
  [Lout],  [no],  [1991],
)

#grid(
  columns: (1fr, 1fr),
  column-gutter: 8mm,
  [
    #note[`column-gutter: 14pt`]
    #table(
      columns: 3,
      column-gutter: 14pt,
      align: (left, center, right),
      table.header([*Language*], [*Typed*], [*Year*]),
      ..langs,
    )
  ],
  [
    #note[the same, plus `table.vline(x: 1)`]
    #table(
      columns: 3,
      column-gutter: 14pt,
      align: (left, center, right),
      table.vline(x: 1),
      table.header([*Language*], [*Typed*], [*Year*]),
      ..langs,
    )
  ],
)
