// A header whose spanning cell reaches over a rule of its own. The rule adds a
// blank row inside the header, which needs a placeholder cell to belong to it,
// and the placeholder must not sit under the spanning cell; it goes in the first
// column nothing covers. The header stays in one piece and repeats whole.
//
// The table has no footer, so its heavy bottom rule is not part of one. Typst
// draws a line along the bottom edge of a table at the foot of every page it
// breaks across, but the air above that rule is a row at the very end of the
// table, so the first page is shorter than the last by that air. That is Typst's
// doing and not something to correct here.
#import "/tests/cases.typ": *
#show: setup
#set page(height: 4.2cm)

#table(
  columns: 3,
  table.vline(x: 1),
  table.header(
    repeat: true,
    table.cell(rowspan: 2)[*Name*], table.cell(colspan: 2)[*Measured*],
    table.hline(start: 1),
    [*Low*], [*High*],
  ),
  ..range(24).map(i => [#(i + 1)]),
)
