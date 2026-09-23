// What happens where two rules meet.
//
// A vertical rule is the one case plain `table` strokes cannot set properly: a
// stroke belongs to a whole cell edge, so it cannot stop short of anything.
// Here the rules are read as lines that cross or merely touch.

#import "/lib.typ": booktabs

#set page(width: 12cm, height: auto, margin: 8mm)
#set text(font: "Libertinus Serif", size: 10pt)
#set table(inset: (x: 6pt, y: 2.7pt))
#show table: booktabs

#table(
  columns: 4,
  align: (left, center, center, right),

  // Thicker than the light rules it meets, so those give way to it. It runs
  // the whole height, which means it only *touches* the heavy rules closing
  // the table and stops short of them rather than cutting through.
  table.vline(x: 1, stroke: 0.9pt),

  table.header([*Release*], [*Typed*], [*GC*], [*Year*]),

  [Typst 0.1], [yes], [yes], [2023],
  [Typst 0.15], [yes], [yes], [2025],

  // Ends exactly at the vertical rule, so the two only meet: neither gives
  // way, and the short rule simply stops short of it.
  table.hline(start: 1),

  [TeX], [no], [no], [1978],
  [Lout], [no], [no], [1991],
)
