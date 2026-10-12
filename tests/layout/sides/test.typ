// An inset names its sides in several ways, and the padding a rule steals from is
// read off it, so each way has to come out as the four sides. `top`, `bottom`,
// `left` and `right` win over `x` and `y`, which win over `rest`, which wins over
// nothing; a single value is every side's. This is read straight off the helper,
// since a table's own inset is folded with the one a `set` rule gives it and so
// cannot be given as `rest` alone.
#import "/tests/cases.typ": *

#let sides = booktyps._sides

#assert.eq(sides(3pt), (top: 3pt, bottom: 3pt, left: 3pt, right: 3pt))
#assert.eq(
  sides((x: 1pt, y: 2pt)),
  (top: 2pt, bottom: 2pt, left: 1pt, right: 1pt),
)
#assert.eq(
  sides((rest: 4pt)),
  (top: 4pt, bottom: 4pt, left: 4pt, right: 4pt),
  message: "`rest` alone is every side",
)
#assert.eq(
  sides((left: 9pt, rest: 4pt)),
  (top: 4pt, bottom: 4pt, left: 9pt, right: 4pt),
  message: "`rest` is what the named sides leave",
)
#assert.eq(
  sides((x: 1pt, rest: 4pt)),
  (top: 4pt, bottom: 4pt, left: 1pt, right: 1pt),
  message: "`x` wins over `rest`, which still fills in `y`",
)
#assert.eq(
  sides((top: 7pt, y: 2pt, x: 1pt, rest: 4pt)),
  (top: 7pt, bottom: 2pt, left: 1pt, right: 1pt),
  message: "a side wins over `y`, which wins over `rest`",
)
#assert.eq(
  sides((left: 1pt)),
  (top: 0pt, bottom: 0pt, left: 1pt, right: 0pt),
  message: "what nothing names is nothing",
)
