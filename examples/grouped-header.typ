// Several rules on one boundary, which is what booktabs' \cmidrule is for.
//
// A grouped header needs one short rule under each group, all at the same
// height. Write them as separate `table.hline`s on the same row: they share the
// one band of air rather than each claiming their own, so the rows below keep
// the pitch a single rule would have given them.

#import "/lib.typ": booktabs

#set page(width: 11cm, height: auto, margin: 8mm)
#set text(font: "Libertinus Serif", size: 10pt)
#set table(inset: (x: 6pt, y: 2.7pt))
#show table: booktabs

#let group(body) = table.cell(colspan: 2, align(center, strong(body)))

#table(
  columns: 6,
  align: (left, center, center, right, right, right),

  table.header(
    // "Params" belongs to no group, so the two rules do not run into one
    // another and each is plainly its own.
    [], group[Accuracy], [], group[Cost],
    // One short rule per group, both on this row. `start` and `end` count
    // column boundaries, so 1-3 underlines the two accuracy columns.
    table.hline(start: 1, end: 3),
    table.hline(start: 4, end: 6),
    [*Model*], [top-1], [top-5], [*Params*], [ms], [MB],
  ),

  [ResNet-50], [76.1], [92.9], [25.6 M], [4.6], [98],
  [ViT-B/16], [81.1], [95.3], [86.6 M], [17.6], [330],
  [EfficientNet-B0], [77.7], [93.5], [5.3 M], [3.9], [21],

  // A footer takes a light rule of its own, as a header does.
  table.footer([*Best*], [81.1], [95.3], [5.3 M], [3.9], [21]),
)
