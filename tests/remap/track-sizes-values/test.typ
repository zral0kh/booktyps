// The sizes the author gave the columns and rows, read off the laid-out table.
// They go to the authored tracks in the order given and nowhere else: the blank
// tracks that rules add have a size of their own. An array repeats its last size
// the way Typst does, so it is written out in full, a single size is every
// track's, and a bare count says only how many there are. `booktabs` is called
// here rather than shown, so that the table it returns can be inspected.
#import "/tests/cases.typ": *
#show: setup

/// The sizes among `sizes` that are the author's, which a blank track never is:
/// the blank ones are plain lengths of a few points.
#let authored(sizes, given) = sizes.filter(size => size in given)

#context {
  // Four rows, two of them with a rule between that adds blank rows, and a thick
  // vertical rule that makes the horizontal ones stop short and adds columns.
  let it = booktabs(table(
    columns: (3cm, 1fr, auto),
    rows: (auto, 14pt, 26pt),
    table.vline(x: 1, stroke: 1.5pt),
    table.hline(y: 2),
    [a], [b], [c], [d], [e], [f], [g], [h], [i], [j], [k], [l],
  ))
  assert(it.columns.len() > 3, message: "the rules should have added columns")
  assert(it.rows.len() > 4, message: "the rules should have added rows")
  assert.eq(
    authored(it.columns, (3cm, 1fr, auto)), (3cm, 1fr, auto),
    message: "the columns keep their sizes, in order",
  )
  assert.eq(
    authored(it.rows, (auto, 14pt, 26pt)), (auto, 14pt, 26pt, 26pt),
    message: "the last row size repeats for the rows past the end of the array",
  )
}

// One size is every track's.
#context {
  let it = booktabs(table(
    columns: 3cm,
    rows: 20pt,
    table.hline(y: 1),
    [a], [b], [c],
  ))
  assert.eq(authored(it.columns, (3cm,)), (3cm,))
  assert.eq(authored(it.rows, (20pt,)), (20pt, 20pt, 20pt))
}

// A count is not a size: every track is as big as it needs to be. Typst hands
// a count over as that many `auto` tracks, which is how it reaches the library.
#context {
  let it = booktabs(table(
    columns: 2,
    rows: 3,
    table.hline(y: 1),
    [a], [b], [c], [d], [e], [f],
  ))
  assert.eq(it.columns.filter(size => size == auto).len(), 2)
  assert.eq(it.rows.filter(size => size == auto).len(), 3)
}
