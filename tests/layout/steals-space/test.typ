// A rule can take its gap out of the padding of the cells beside it instead of
// adding it to the table. Where the padding covers the gap the rows keep the
// pitch they had with no rule at all; where it falls short, only the shortfall
// is added.
#import "/tests/cases.typ": *
#show: setup

#let pad = 2.7pt
#let rows(tag) = (
  [#metadata(none)#label(tag + "-0")a], [x],
  [#metadata(none)#label(tag + "-1")b], [y],
)

// No rule between the two rows: the pitch to match.
#table(columns: 2, ..rows("plain"))

// The default: the rule adds its gap, so the rows move apart.
#table(columns: 2, rows("adds").at(0), rows("adds").at(1), table.hline(), ..rows("adds").slice(2))

#let split(tag, ..bind) = [
  #show table: booktabs.with(..bind)
  #table(columns: 2,
    [#metadata(none)#label(tag + "-0")a], [x],
    table.hline(),
    [#metadata(none)#label(tag + "-1")b], [y],
  )
]

// Told to steal, the rule takes 2.7pt from each neighbour and adds nothing.
#split("steals", rule-steals-space: true)

// The cells have only 1pt to give, so 1.7pt of each gap is still added.
#let thin = 1pt
#[
  #set table(inset: (x: 6pt, y: thin))
  #table(columns: 2, ..rows("thin-plain"))
  #split("thin", rule-steals-space: true)
]

// A label on the rule overrides the table's setting, either way.
#[
  #show table: booktabs.with(rule-steals-space: false)
  #table(columns: 2,
    [#metadata(none)<marked-0>a], [x],
    [#table.hline()<steals-space>],
    [#metadata(none)<marked-1>b], [y],
  )
]

#context {
  let y(tag, i) = query(label(tag + "-" + str(i))).first().location().position().y
  let pitch(tag) = y(tag, 1) - y(tag, 0)
  let near(a, b) = calc.abs((a - b).pt()) < 0.01

  assert(
    near(pitch("adds"), pitch("plain") + 2 * pad),
    message: "by default a rule adds its whole gap, got "
      + repr(pitch("adds") - pitch("plain")),
  )
  assert(
    near(pitch("steals"), pitch("plain")),
    message: "a stealing rule should leave the pitch alone, got "
      + repr(pitch("steals") - pitch("plain")),
  )
  assert(
    near(pitch("thin"), pitch("thin-plain") + 2 * (pad - thin)),
    message: "where the padding falls short only the shortfall should be added, got "
      + repr(pitch("thin") - pitch("thin-plain")),
  )
  assert(
    near(pitch("marked"), pitch("plain")),
    message: "`<steals-space>` should override the table, got "
      + repr(pitch("marked") - pitch("plain")),
  )
}
