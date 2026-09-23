// The table from the booktabs manual, which is the look this package is after,
// set with booktabs' own spacing.
//
// In LaTeX it is written with \toprule, \cmidrule(r){1-2}, \midrule and
// \bottomrule. Here none of those appear: the heavy rules come from the table
// being a table, the light one from `table.header`, and only the short rule
// under "Item" has to be asked for.

#import "/lib.typ": booktabs

#set page(width: 9cm, height: auto, margin: 8mm)
#set text(font: "Libertinus Serif", size: 10pt)
#set table(inset: (x: 6pt, y: 2.7pt))

// booktabs sets \aboverulesep to 0.4ex and \belowrulesep to 0.65ex, so a rule
// sits nearer the line above it than the one below. Typst has no `ex`, and the
// x-height it stands for is a property of each font rather than a fixed
// fraction of the size: for Libertinus Serif it is 0.429em, which puts the two
// at 0.172em and 0.279em. The package itself defaults to the same gap either
// side, which reads just as well and needs no per-font number.
#show table: booktabs.with(rule-inset: (top: 0.172em, bottom: 0.279em))

#table(
  columns: (auto, auto, auto),
  align: (left, left, right),

  table.header(
    // "Item" spans the two columns the short rule underlines.
    table.cell(colspan: 2, align(center)[Item]),
    [],
    // booktabs' \cmidrule(r){1-2}: a light rule over those two columns only.
    table.hline(start: 0, end: 2),
    [Animal], [Description], [Price (\$)],
  ),

  [Gnat], [per gram], [13.65],
  // An empty cell continues the row above, as in the original.
  [], [each], [0.01],
  [Gnu], [stuffed], [92.50],
  [Emu], [stuffed], [33.33],
  [Armadillo], [frozen], [8.99],
)
