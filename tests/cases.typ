// Shared setup. `tt` only collects files named `test.typ`, so this one is just
// a module the tests import.
#import "/lib.typ": booktabs

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
