// A header and a footer carry the lines inside them, and a line carried by one
// stays within it: a vertical rule down the whole table is cut at the header's
// edge, the body's and the footer's, and each piece sits in the part that holds
// it, so that a repeated header repeats its piece and no more. A reference image
// cannot tell a cut line from several drawn over one another. `booktabs` is
// called here rather than shown, so that the table it returns can be inspected.
#import "/tests/cases.typ": *
#show: setup

#context {
  let it = booktabs(table(
    columns: 3,
    table.vline(x: 1),
    table.header(..head),
    ..rows,
    table.footer(..foot),
  ))
  let header = it.children.find(child => child.func() == table.header)
  let footer = it.children.find(child => child.func() == table.footer)
  let body = it.children.filter(child => child.func() == table.vline)
  let first-body = cell-of(it, [Row 1]).y
  let after-body = cell-of(it, [Row 3]).y + 1

  let pieces(part) = part.children.filter(child => child.func() == table.vline).map(line => line.fields())
  let in-header = pieces(header)
  let in-footer = pieces(footer)
  assert(in-header.len() > 0 and in-footer.len() > 0, message: "each part should hold a piece")
  assert(
    in-header.all(line => line.end <= first-body),
    message: "the header's piece should end where the header does, got "
      + repr(in-header.map(line => (line.start, line.end))) + " against " + repr(first-body),
  )
  assert(
    in-footer.all(line => line.start >= after-body),
    message: "the footer's piece should start where the footer does, got "
      + repr(in-footer.map(line => (line.start, line.end))) + " against " + repr(after-body),
  )
  for line in body.map(line => line.fields()) {
    assert(
      line.start >= first-body and line.end <= after-body,
      message: "a piece in the body should stay in the body, got "
        + repr((line.start, line.end)),
    )
  }
}
