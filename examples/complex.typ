#import "/lib.typ": booktabs

#set page(width: 12cm, height: auto, margin: 6mm)
#set text(font: "Libertinus Serif", size: 10pt)
#set table(inset: (x: 6pt, y: 2.7pt))
#show table: booktabs

#align(center,table(
  columns: 4,
  align: (left, center, center, right),
  // Thicker than the rules it meets, so the horizontal ones give way to it.
  table.vline(x: 1, stroke: 1.2pt),
  table.header([*Language*], [*Typed*], [*GC*], [*Year*]),
  [Typst], [yes], [yes], [2019],
  [Rust], [yes], [no], [2015],
  // Covers only the columns it spans, like booktabs' \cmidrule.
  table.hline(start: 1, end: 3),
  [TeX], [no], [no], [1978],
  [Lout], [no], [no], [1991],
  table.footer([*Total*], [], [], [4]),
))
