// Two horizontal rules that end where the next begins simply join up: they are
// two strokes lying end to end, with nothing between them to give way to. Only
// a vertical rule can part them, and it need not be visible to do it — a white
// one breaks the join while drawing nothing itself.
#import "/tests/cases.typ": *
#show: setup

#let body = ([a], [b], [c], [d], [a], [b], [c], [d])

// Joined: the two read as one rule across the table.
#table(columns: 4, align: center,
  table.hline(y: 1, start: 0, end: 2),
  table.hline(y: 1, start: 2, end: 4),
  ..body,
)

// Parted, by a rule that leaves no mark of its own.
#table(columns: 4, align: center,
  table.vline(x: 2, stroke: white),
  table.hline(y: 1, start: 0, end: 2),
  table.hline(y: 1, start: 2, end: 4),
  ..body,
)
