// Rules sharing a boundary share one band of air, so when they ask for
// different amounts the widest wins. Anything less would crowd the rule that
// asked for more, and the band cannot be two heights at once.
#import "/tests/cases.typ": *
#show: setup

// The left rule asks for little air, the right one for a lot.
#let roomy(x, y, rule) = if rule.fields().at("start", default: 0) == 0 { 1pt } else { 5pt }

#show table: booktabs.with(rule-inset: roomy)

// Each alone, for the two pitches to compare against.
#table(columns: 4,
  [#metadata(none)<narrow-0>a], [b], [c], [d],
  table.hline(y: 1, start: 0, end: 1),
  [#metadata(none)<narrow-1>a], [b], [c], [d],
)
#table(columns: 4,
  [#metadata(none)<wide-0>a], [b], [c], [d],
  table.hline(y: 1, start: 3, end: 4),
  [#metadata(none)<wide-1>a], [b], [c], [d],
)
// Both at once: the band has to be one height, and it is the wider ask.
#table(columns: 4,
  [#metadata(none)<both-0>a], [b], [c], [d],
  table.hline(y: 1, start: 0, end: 1),
  table.hline(y: 1, start: 3, end: 4),
  [#metadata(none)<both-1>a], [b], [c], [d],
)

#context {
  let y(tag, i) = query(label(tag + "-" + str(i))).first().location().position().y
  let pitch(tag) = y(tag, 1) - y(tag, 0)
  let near(a, b) = calc.abs((a - b).pt()) < 0.01

  assert(
    pitch("wide") > pitch("narrow"),
    message: "the roomier rule should push the rows further apart",
  )
  assert(
    near(pitch("both"), pitch("wide")),
    message: "two rules on one boundary should take the wider of the two asks, "
      + "got " + repr(pitch("both")) + " against " + repr(pitch("wide")),
  )
}
