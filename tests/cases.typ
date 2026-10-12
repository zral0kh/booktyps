// Shared setup. `tt` only collects files named `test.typ`, so this one is just
// a module the tests import.
#import "/lib.typ" as booktyps

/// The package's sizes are given in `em`, so they would follow this suite's
/// text size. The tests are about where the rules go rather than how thick the
/// defaults are, so they are pinned here and quoted as plain lengths.
#let booktabs = booktyps.booktabs.with(
  heavy: 0.9pt,
  light: 0.5pt,
  vertical: 0.4pt,
  rule-inset: 2.7pt,
)

/// A page that is only as tall as the table on it, so a reference image shows
/// the table and nothing else.
#let setup(body) = {
  set page(width: 9cm, height: auto, margin: 5mm)
  set text(font: "Libertinus Serif", size: 10pt)
  // The package leaves the cell padding alone, so the suite pins it, exactly
  // as a document using booktyps would.
  set table(inset: (x: 6pt, y: 2.7pt))
  show table: booktabs
  body
}

// The same content throughout, so that what differs between two references is
// the rules and the spacing, never the text.
#let head = ([*Column A*], [*Column B*], [*Column C*])
#let rows = (
  [Row 1], [Text], [42.0],
  [Row 2], [Text], [31.4],
  [Row 3], [Text], [7.25],
)
#let foot = ([*Total*], [], [80.65])

/// The rules a table carries, as the arguments of each line, whether they sit
/// among its children or inside its header or footer. `kind` is `table.hline`
/// or `table.vline`; the result is what `booktabs` laid out, so a track here is
/// a laid-out row or column, blank ones included.
#let lines-of(it, kind) = (
  it
    .children
    .map(child => if child.func() in (table.header, table.footer) {
      child.children
    } else { (child,) })
    .flatten()
    .filter(child => child.func() == kind)
    .map(child => child.fields())
)

/// Whether a horizontal rule is drawn along the top of row `y` at column `x`.
#let hline-covers(it, y, x) = lines-of(it, table.hline).any(line => (
  line.y == y and line.start <= x and x < line.end
))

/// Whether a vertical rule is drawn along the left of column `x` at row `y`.
#let vline-covers(it, x, y) = lines-of(it, table.vline).any(line => (
  line.x == x and line.start <= y and y < line.end
))

/// The cells a table carries, as their arguments, in the header and footer as
/// well as the body. The blank placeholders `booktabs` puts inside a part have
/// an empty body and are left out. A cell's `body` is the content it was given,
/// so a test finds one by comparing it with the same content.
#let cells-of(it) = (
  it
    .children
    .map(child => if child.func() in (table.header, table.footer) {
      child.children
    } else { (child,) })
    .flatten()
    .filter(child => child.func() == table.cell)
    .map(child => child.fields())
    .filter(cell => cell.body != [])
)

/// The cell of a returned table whose content is `body`.
#let cell-of(it, body) = {
  let found = cells-of(it).filter(cell => cell.body == body)
  assert.eq(found.len(), 1, message: "expected one cell holding " + repr(body))
  found.first()
}

/// Whether two of a table's cells claim the same slot of the grid.
#let overlaps(it) = {
  let taken = (:)
  let clash = false
  for cell in cells-of(it) {
    for y in range(cell.y, cell.y + cell.at("rowspan", default: 1)) {
      for x in range(cell.x, cell.x + cell.at("colspan", default: 1)) {
        let key = str(x) + "," + str(y)
        if key in taken { clash = true }
        taken.insert(key, true)
      }
    }
  }
  clash
}
