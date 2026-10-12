// A header and a footer that repeat across a page break take their rules with
// them: the heavy rule above, the light one under the header and above the
// footer, the heavy one below, and the vertical rules running through each part.
// The rules are lines inside the header and footer, so a repeat is a repeat of
// them as well, and a rule that belongs to the body is not repeated with them.
#import "/tests/cases.typ": *
#show: setup
#set page(height: 4.6cm)

#table(
  columns: 3,
  table.vline(x: 1),
  table.vline(x: 2, stroke: 1.2pt),
  table.header(repeat: true, ..head),
  ..range(18).map(i => [Row #(i + 1)]),
  table.hline(y: 4, start: 1),
  table.footer(repeat: true, ..foot),
)
