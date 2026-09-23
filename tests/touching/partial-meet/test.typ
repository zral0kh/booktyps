// A meeting may stop short by less than the air around the rule. The blank
// space beside a rule is then divided, and the meeting rule reaches part of the
// way into it: here the three vertical rules stop short of the heavy rules by
// nothing, by half the air, and by all of it, left to right.
#import "/tests/cases.typ": *
#show: setup
#show table: booktabs.with(rule-inset: (x, y, rule) => (
  x: 6pt,
  y: 2.7pt,
  meet: if x == 1 { 0pt } else if x == 2 { 1.35pt } else { 2.7pt },
))

#table(
  columns: 4,
  align: center,
  table.vline(x: 1),
  table.vline(x: 2),
  table.vline(x: 3),
  [a], [b], [c], [d],
  [a], [b], [c], [d],
)
