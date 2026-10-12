// What the table handed to Typst says about gutters. An array of gutters repeats
// its last size for the gaps past its end, so it is spelt out in full, one size
// for each gap between authored columns, and given to the gaps that lie between
// two of them. Where a rule stands, the gutter is blank tracks beside it, and
// the gaps next to those are none. `booktabs` is called here rather than shown,
// so that the table it returns can be inspected.
#import "/tests/cases.typ": *
#show: setup

#let sample(..args) = table(
  columns: 4,
  inset: (x: 6pt, y: 2.7pt),
  ..args,
  [a], [b], [c], [d], [e], [f], [g], [h],
)

#context {
  // No rule: the gaps keep the author's sizes, the last of the array repeated.
  let it = booktabs(sample(column-gutter: (4pt, 24pt)))
  assert.eq(
    it.column-gutter.map(gap => gap.length), (4pt, 24pt, 24pt),
    message: "an array of gutters is spelt out in full",
  )
  assert.eq(it.columns.len(), 4, message: "and nothing is added to the columns")

  // One size is every gap's.
  let one = booktabs(sample(column-gutter: 7pt))
  assert.eq(one.column-gutter.map(gap => gap.length), (7pt, 7pt, 7pt))

  // None at all, none given on.
  assert(
    "column-gutter" not in booktabs(sample()).fields(),
    message: "a table with no gutters should not be given any",
  )
}

// A rule in the second gap: that gap is blank tracks, and the gaps either side
// of it keep their own sizes, which are the first and the last of the array.
#context {
  let it = booktabs(sample(column-gutter: (4pt, 24pt, 10pt), table.vline(x: 2)))
  let gaps = it.column-gutter.map(gap => gap.length)
  assert.eq(gaps.len(), it.columns.len() - 1, message: "one gap between every two tracks")
  assert.eq(gaps.first(), 4pt, message: "the gap before the rule keeps its size")
  assert.eq(gaps.last(), 10pt, message: "and the gap after it")
  assert(
    gaps.slice(1, -1).all(gap => gap == 0pt),
    message: "and the gaps beside the blank tracks are none, got " + repr(gaps),
  )
  // The 24pt at the rule is the blank tracks' to hold, half each side.
  let blank = it.columns.filter(size => type(size) == relative or type(size) == length)
  let room = blank.filter(size => size.length == 12pt)
  assert.eq(room.len(), 2, message: "half of the 24pt each side of the rule, got " + repr(it.columns))
}

// Rows, the same.
#context {
  let it = booktabs(table(
    columns: 2,
    inset: (x: 6pt, y: 2.7pt),
    row-gutter: (3pt, 20pt),
    table.hline(y: 2),
    [a], [b], [c], [d], [e], [f], [g], [h],
  ))
  let gaps = it.row-gutter.map(gap => gap.length)
  assert.eq(gaps.len(), it.rows.len() - 1)
  // The array is (3pt, 20pt) for the three gaps, so 3pt, 20pt, 20pt. The hline
  // stands at the boundary after row 1, the second of them, which is blank
  // tracks', so what is left is the first and the last. The heavy rules at the
  // table's edges add blank rows of their own, where there is no gutter.
  assert.eq(
    gaps.filter(gap => gap != 0pt), (3pt, 20pt),
    message: "the gutter at the rule is the blank tracks', so the others are left, got " + repr(gaps),
  )
}

// A gutter that is not a length cannot be halved, so none is kept at a rule,
// and the author is told. A warning is content, so what comes back is the table
// among it.
#context {
  let made = booktabs(sample(column-gutter: 1fr, table.vline(x: 1)))
  let it = made.children.find(child => child.func() == table)
  assert.eq(it.columns.len(), 4, message: "no blank tracks for a gutter that cannot be split")
}
