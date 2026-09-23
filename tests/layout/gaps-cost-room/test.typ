// A gap has to come from somewhere, so a rule that gives way widens the table
// by exactly what it stops short by, and a rule that gives way to nothing costs
// nothing at all. `meet: 0pt` is the way back to rules that run into each other.
#import "/tests/cases.typ": *
#show: setup

#let pad = 2.7pt
#let body(tag) = (
  [#metadata(none)#label(tag + "-first")a], [b], [c], [#metadata(none)#label(tag + "-last")d],
  [a], [b], [c], [d],
)

// Nothing to give way to: no vertical rule at all.
#table(columns: 4, ..body("plain"))

// A vertical rule that no horizontal rule reaches costs nothing either.
#table(columns: 4, table.vline(x: 2), table.hline(y: 1, start: 3), ..body("clear"))

// The horizontal rule runs up to the vertical one and stops short of it.
#table(columns: 4, table.vline(x: 2), table.hline(y: 1, start: 2), ..body("meet"))

// Told to stop short by nothing, it runs into it instead, and costs no width.
#[
  #show table: booktabs.with(rule-inset: (x: pad, y: pad, meet: 0pt))
  #table(columns: 4, table.vline(x: 2), table.hline(y: 1, start: 2), ..body("joined"))
]

// Cut clean through, the horizontal rule gives way on both sides.
#table(columns: 4, table.vline(x: 2, stroke: 0.9pt), table.hline(y: 1), ..body("cut"))

#context {
  let x(tag, which) = query(label(tag + "-" + which)).first().location().position().x
  let near(a, b) = calc.abs((a - b).pt()) < 0.01
  let width(tag) = x(tag, "last") - x(tag, "first")
  let extra(tag) = width(tag) - width("plain")

  for (tag, cost, why) in (
    ("clear", 0pt, "a vertical rule nothing reaches"),
    ("joined", 0pt, "a meeting told to stop short by nothing"),
    ("meet", pad, "a rule stopping short where it meets another"),
    ("cut", 2 * pad, "a rule cut clean through, which gives way on both sides"),
  ) {
    assert(
      near(extra(tag), cost),
      message: why + " should cost " + repr(cost) + ", got " + repr(extra(tag)),
    )
  }
}
