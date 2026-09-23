// `rule-inset` as a function gives each rule its own air. One of `x` and `y` is
// always `none`, which is also how to tell the two directions apart: here the
// heavy rules closing the table get room, the light one under the header is
// kept tight, and the vertical rule running through them is given a wide berth.
#import "/tests/cases.typ": *
#show: setup
#show table: booktabs.with(
  break-rule: table.hline,
  rule-inset: (x, y, rule) => if x != none { 6pt } else if rule.stroke == 0.5pt {
    1pt
  } else { 5pt },
)

#table(
  columns: 3,
  align: (left, center, right),
  table.vline(x: 1),
  table.header(..head),
  ..rows,
)
