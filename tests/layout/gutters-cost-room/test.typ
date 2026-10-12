// The author's gutter is room beside a rule, as the padding of the cells is: the
// rule's air is added to it or taken out of it, as `rule-steals-space` has it,
// and a rule standing in a gutter costs the table what it would have cost
// without one. The sizes are measured off the tables themselves, which a
// reference image can only show as a few points. `booktabs` is called here
// rather than shown, so that the table it returns can be measured, and the
// tables are given their inset, since one built by hand does not pick up the
// suite's `set table`. The air is the suite's `rule-inset`, 2.7pt, a side.
#import "/tests/cases.typ": *
#show: setup

#let air = 2.7pt
#let injects = booktabs.with(vertical-space: true)
#let steals = booktabs.with(vertical-space: true, rule-steals-space: true)

#let sample(..args) = table(
  columns: 3,
  inset: (x: 6pt, y: 2.7pt),
  ..args,
  [a], [b], [c], [d], [e], [f],
)

/// Whether two lengths are the same to within a hundredth of a point.
#let same(a, b) = calc.abs((a - b).pt()) < 0.01
#let wide(it) = measure(it).width
#let tall(it) = measure(it).height

// Across: a vertical rule in a column gutter.
#context {
  for gutter in (14pt, 8pt, 4pt, 0pt) {
    let without = sample(column-gutter: gutter)
    let rule = sample(column-gutter: gutter, table.vline(x: 1))
    assert(
      same(wide(injects(rule)), wide(injects(without)) + 2 * air),
      message: "a rule in a gutter of " + repr(gutter) + " adds its air on top of it, "
        + "being wider by " + repr(wide(injects(rule)) - wide(injects(without)))
        + " rather than 2 * air",
    )
    assert(
      same(wide(steals(rule)), wide(steals(without))),
      message: "a stealing rule in a gutter of " + repr(gutter) + " should cost no width, "
        + "being wider by " + repr(wide(steals(rule)) - wide(steals(without))),
    )
  }
}

// Down: a horizontal rule in a row gutter, the same. The heavy rules above and
// below the table take their air as well, in the way the table is set to, so each
// way is measured against a table of its own kind without the rule.
#context {
  for gutter in (14pt, 4pt, 0pt) {
    let without = sample(row-gutter: gutter)
    let rule = sample(row-gutter: gutter, table.hline(y: 1))
    assert(
      same(tall(injects(rule)), tall(injects(without)) + 2 * air),
      message: "a rule in a row gutter of " + repr(gutter) + " adds its air on top of it, "
        + "being taller by " + repr(tall(injects(rule)) - tall(injects(without))),
    )
    assert(
      same(tall(steals(rule)), tall(steals(without))),
      message: "a stealing rule in a row gutter of " + repr(gutter) + " should cost no height, "
        + "being taller by " + repr(tall(steals(rule)) - tall(steals(without))),
    )
  }
}

// The gutter is the author's own, so a table with one is as wide as the gutter
// and the cells make it, rules or none: it does not become a different table.
#context {
  let plain = booktabs(sample())
  let gapped = booktabs(sample(column-gutter: 10pt))
  assert(same(wide(gapped), wide(plain) + 2 * 10pt), message: "two gutters of 10pt widen it by 20pt")
}
