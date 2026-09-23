// With `auto`, the thinner rule gives way and the thicker runs through. A
// sideways table has no header to read a rule off, so both rules here are the
// author's: the thin horizontal ones break at the thick vertical one.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 4,
  align: (left, center, center, center),
  table.vline(x: 1, stroke: 0.9pt),
  table.hline(y: 1, stroke: 0.4pt),
  table.hline(y: 2, stroke: 0.4pt),
  [*Language*], [Typst], [TeX], [Lout],
  [*Year*], [2019], [1978], [1991],
  [*Typed*], [yes], [no], [no],
)
