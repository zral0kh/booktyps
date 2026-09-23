// Read the strokes straight off the laid-out table, which pins what a
// reference image can only show: a rule is interrupted where it is genuinely
// cut, and nowhere else. `booktabs` is called here rather than shown, so that
// the table it returns can be inspected; the calls sit in a `context` because
// a show rule would otherwise be supplying one, and the gaps are resolved to
// absolute lengths so that `em` and `pt` can be ordered against each other.
#import "/tests/cases.typ": *
#show: setup

#let width(it) = if type(it.columns) == int { it.columns } else { it.columns.len() }
#let height(it) = it.rows.len()

/// The laid-out column a vertical rule was drawn in, found by looking for one.
#let vline-column(it) = {
  let found = ()
  for x in range(width(it)) {
    if range(height(it)).any(y => (it.stroke)(x, y).left != none) { found.push(x) }
  }
  found
}

// A vertical rule spanning every row touches the heavy rules closing the table
// but never crosses them, so those must run the whole way across.
#context {
  let it = booktabs(table(
    columns: 3,
    table.vline(x: 1, stroke: 0.9pt),
    table.header(..head),
    ..rows,
  ))
  let last = height(it) - 1
  for x in range(width(it)) {
    assert(
      (it.stroke)(x, 0).top != none,
      message: "the top rule should reach across column " + str(x)
        + ", which the vertical rule only touches",
    )
    assert(
      (it.stroke)(x, last).bottom != none,
      message: "the bottom rule should reach across column " + str(x),
    )
  }
}

// A horizontal rule that stops where the vertical one stands does not cut it.
// The vertical rule still stops short of the heavy rules closing the table,
// which are the first and last laid-out rows, but runs on through everything
// between them.
#context {
  let it = booktabs(table(
    columns: 4,
    table.vline(x: 1),
    table.hline(y: 2, start: 1, stroke: 0.9pt),
    [a], [b], [c], [d],
    [a], [b], [c], [d],
    [a], [b], [c], [d],
  ))
  let columns = vline-column(it)
  assert.eq(columns.len(), 1, message: "expected exactly one vertical rule")
  let x = columns.first()
  for y in range(1, height(it) - 1) {
    assert(
      (it.stroke)(x, y).left != none,
      message: "the vertical rule should run through row " + str(y)
        + ": the horizontal rule starts at it and so never cuts it",
    )
  }
}

// Where it does reach past, though, the vertical rule is cut, and only in the
// two blank rows that the cutting rule's air opens up either side of it.
#context {
  let it = booktabs(table(
    columns: 4,
    table.vline(x: 1),
    table.hline(y: 2, stroke: 0.9pt),
    [a], [b], [c], [d],
    [a], [b], [c], [d],
    [a], [b], [c], [d],
  ))
  let x = vline-column(it).first()
  let gaps = range(1, height(it) - 1).filter(y => (it.stroke)(x, y).left == none)
  assert.eq(
    gaps.len(), 2,
    message: "a cut vertical rule should be absent from exactly the two blank "
      + "rows either side of the rule cutting it, got " + repr(gaps),
  )
}
