// A rule that steals its gap takes it from the padding of the cells beside it.
// A cell that spans several rows or columns is beside the rule only along the
// edge it ends at, so that is where it gives: the bottom padding of a rowspan is
// taken for a rule under its last row, the right padding of a colspan for a rule
// beside its last column, and a span gives the same as a plain cell ending there.
// The padding is read off the cell the table is given, which a reference image
// would show only as a few points of height. The tables are given their inset
// here, since one built by hand does not pick up the suite's `set table`. `booktabs` is called here rather
// than shown, so that the table it returns can be inspected.
#import "/tests/cases.typ": *
#show: setup

#let steals = booktabs.with(rule-steals-space: true, vertical-space: true)

/// A length, whether it comes as one or as a relative one with no percentage.
#let length-of(value) = if type(value) == relative { value.length } else { value }

/// Whether two lengths are the same to within a hundredth of a point.
#let same(a, b) = calc.abs((length-of(a) - length-of(b)).pt()) < 0.01

#context {
  let it = steals(table(
    columns: 2,
    inset: (x: 6pt, y: 2.7pt),
    table.cell(rowspan: 2)[tall], [a],
    [b],
    table.hline(),
    [c], [d],
  ))
  let tall = cell-of(it, [tall])
  let b = cell-of(it, [b])
  let padding = 2.7pt
  assert(
    same(tall.inset.bottom, 0pt),
    message: "the rule under the span's last row should have taken its bottom "
      + "padding, left with " + repr(tall.inset.bottom) + " of " + repr(padding),
  )
  assert(
    same(tall.inset.bottom, b.inset.bottom),
    message: "a span should give what a plain cell ending at the same rule gives",
  )
  assert(
    same(cell-of(it, [a]).inset.bottom, padding),
    message: "a cell with no rule under it gives nothing",
  )
}

#context {
  let it = steals(table(
    columns: 3,
    inset: (x: 6pt, y: 2.7pt),
    table.vline(x: 2),
    table.cell(colspan: 2)[wide], [c],
    [a], [b], [d],
  ))
  let wide = cell-of(it, [wide])
  let b = cell-of(it, [b])
  assert(
    same(wide.inset.right, b.inset.right),
    message: "the vertical rule beside the span's last column should take from "
      + "the span's right padding as from a plain cell's, left with "
      + repr(wide.inset.right) + " against " + repr(b.inset.right),
  )
  assert(
    length-of(wide.inset.right) < 6pt,
    message: "something should have been taken from the right padding",
  )
  assert(
    same(wide.inset.left, 6pt),
    message: "the left padding is next to no rule and stays",
  )
}
