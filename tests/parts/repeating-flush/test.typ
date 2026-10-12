// With no air around the rules there is no blank track for a part's rule to sit
// on, so the rule under a repeating header and over a repeating footer lies on
// the very edge of the part. It is still repeated with it: the header on the
// second page keeps the light rule under it, and the footer the one over it.
#import "/tests/cases.typ": *
#show: setup
#show table: booktyps.booktabs.with(
  heavy: 0.9pt, light: 0.5pt, vertical: 0.4pt, rule-inset: 0pt,
)
#set page(height: 4.2cm)

#table(
  columns: 3,
  table.header(repeat: true, ..head),
  ..range(30).map(i => [Row #(i + 1)]),
  table.footer(repeat: true, ..foot),
)
