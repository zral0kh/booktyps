// The rules must not disturb the table's spacing: the blank rows that hold the
// vertical rules away from a horizontal one take their height out of what the
// cell inset contributes, so a rule adds a known amount and nothing else moves.
#import "/tests/cases.typ": *
#show: setup

#let rule-pad = 2.7pt
#let mark(name) = metadata(none)

#table(columns: 2,
  [#metadata(none)<plain-0>a], [x],
  [#metadata(none)<plain-1>b], [y],
  [#metadata(none)<plain-2>c], [z],
)

#table(columns: 2,
  table.header([#metadata(none)<head-h>H], [K]),
  [#metadata(none)<head-0>a], [x],
  [#metadata(none)<head-1>b], [y],
)

#table(columns: 2,
  [#metadata(none)<line-0>a], [x],
  table.hline(),
  [#metadata(none)<line-1>b], [y],
)

#table(columns: 2,
  [#metadata(none)<foot-0>a], [x],
  table.footer([#metadata(none)<foot-f>F], [K]),
)

#context {
  let at(name) = query(name).first().location().position()
  let near(a, b) = calc.abs((a - b).pt()) < 0.01
  let pitch = at(<plain-1>).y - at(<plain-0>).y

  assert(
    near(at(<plain-2>).y - at(<plain-1>).y, pitch),
    message: "rows with no rule between them should sit at an even pitch",
  )
  assert(
    near(at(<head-1>).y - at(<head-0>).y, pitch),
    message: "a header must not change the pitch of the body rows",
  )
  for (gap, what) in (
    (at(<head-0>).y - at(<head-h>).y, "a header's rule"),
    (at(<line-1>).y - at(<line-0>).y, "an hline"),
    (at(<foot-f>).y - at(<foot-0>).y, "a footer's rule"),
  ) {
    assert(
      near(gap, pitch + 2 * rule-pad),
      message: what + " should add exactly twice the rule padding, got " + repr(gap),
    )
  }
  assert(
    near(at(<plain-0>).x, at(<head-0>).x),
    message: "rules should not move the columns",
  )
}
