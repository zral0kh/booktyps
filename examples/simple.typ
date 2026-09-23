#import "/lib.typ": booktabs

#set page(width: 10cm, height: auto, margin: 6mm)
#set text(font: "Libertinus Serif", size: 10pt)
#set table(inset: (x: 6pt, y: 2.7pt))
#show table: booktabs

#align(center,table(
  columns: 3,
  align: (left, center, right),
  table.header([*Language*], [*Typed*], [*Year*]),
  [Typst], [yes], [2019],
  [TeX], [no], [1978],
  [Lout], [no], [1991],
))
