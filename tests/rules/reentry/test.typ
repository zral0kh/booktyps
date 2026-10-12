// The table `booktabs` returns goes back through the show rule that made it, and
// through any other rule on `table`, so it has to be recognised and handed back
// as it is. A table transformed twice is built from the first one's output, and
// each pass is bigger than the last. What marks it is a label of its own, not
// anything the table is made of: a `stroke` the author gives, even a function of
// the kind the output used to carry, is only another stroke to ignore, and
// dropping or passing on an argument cannot lose the mark. `booktabs` is called
// here rather than shown, so that the table it returns can be inspected.
#import "/tests/cases.typ": *
#show: setup

/// How much a table carries: its cells and its lines.
#let size-of(it) = (
  cells: cells-of(it).len(),
  hlines: lines-of(it, table.hline).len(),
  vlines: lines-of(it, table.vline).len(),
)

#let sample(..args) = table(
  columns: 3,
  ..args,
  table.vline(x: 1),
  table.header(..head),
  ..rows,
  table.footer(..foot),
)

// A table given the look is handed back as it is when it meets a rule again.
#context {
  let once = booktabs(sample())
  let twice = booktabs(once)
  assert.eq(size-of(twice), size-of(once), message: "transformed a second time")
  assert.eq(size-of(booktabs(booktabs(twice))), size-of(once))
  assert(
    size-of(once).hlines > 0 and size-of(once).vlines > 0,
    message: "the first pass should have drawn the rules",
  )
}

// A stroke of the author's is ignored, whatever it is, and the table is still
// given the look: it is not mistaken for one that already has it. A function
// was the mark once, so that is the stroke to try.
#context {
  let plain = size-of(booktabs(sample()))
  for stroke in (red + 1pt, (x, y) => red, (x: blue), none) {
    assert.eq(
      size-of(booktabs(sample(stroke: stroke))), plain,
      message: "a table with the stroke " + repr(stroke) + " should come out as one without",
    )
  }
}

// Under the show rules too: the one this suite sets up, the one asked for here,
// and one that looks at what the others made. Each table is seen once by the
// last, as the output of the first and not as something to transform.
#show table: it => [#metadata(size-of(it))<seen>#it]
#show table: booktabs.with(heavy: 0.9pt, light: 0.5pt, vertical: 0.4pt, rule-inset: 2.7pt)
#sample()

#context {
  let seen = query(<seen>)
  assert.eq(seen.len(), 1, message: "the table should reach the last rule once")
  assert.eq(
    seen.first().value, size-of(booktabs(sample())),
    message: "and it should be the output of one pass, not of several",
  )
}
