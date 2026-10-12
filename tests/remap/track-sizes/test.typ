// Track sizes are the author's, given to the authored tracks only. `rows` used
// to be overwritten with `auto`. An array repeats its last size, so it is spelt
// out for every authored row; left to repeat it would reach the blank tracks the
// rules add and push the sizes onto the wrong rows. The columns are the same,
// with a vline making the hlines break and adding columns of their own.
#import "/tests/cases.typ": *
#show: setup
#set table(fill: (x, y) => if calc.rem(y, 2) == 0 { luma(225) })

#table(
  columns: (3cm, 1fr, auto),
  rows: (auto, 14pt, 26pt),
  table.vline(x: 1, stroke: 1.5pt),
  table.hline(y: 2),
  [a], [b], [c], [d], [e], [f], [g], [h], [i], [j], [k], [l],
)
