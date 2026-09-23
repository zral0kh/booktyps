// Rules sharing a boundary share one gap, so they cannot disagree about where
// it comes from. Where they do, the safe reading wins: none of them steals,
// since adding space can only ever make the table bigger, never overlap
// anything. A `uniwarn` warning says so, under the namespace "booktyps".
#import "/tests/cases.typ": *
#show: setup

#let pad = 2.7pt
#let pair(tag, second) = table(columns: 4,
  [#metadata(none)#label(tag + "-0")a], [b], [c], [d],
  [#table.hline(start: 0, end: 2)<steals-space>],
  second,
  [#metadata(none)#label(tag + "-1")a], [b], [c], [d],
)

// Nothing between the rows, for the pitch to measure against.
#table(columns: 4,
  [#metadata(none)<plain-0>a], [b], [c], [d],
  [#metadata(none)<plain-1>a], [b], [c], [d],
)

// Both marked: they agree, so the gap comes out of the cells.
#pair("agree", [#table.hline(start: 2, end: 4)<steals-space>])

// Only one marked: they disagree, so neither steals and the gap is added.
#pair("clash", table.hline(start: 2, end: 4))

#context {
  let y(tag, i) = query(label(tag + "-" + str(i))).first().location().position().y
  let pitch(tag) = y(tag, 1) - y(tag, 0)
  let near(a, b) = calc.abs((a - b).pt()) < 0.01

  assert(
    near(pitch("agree"), pitch("plain")),
    message: "rules that agree to steal should leave the pitch alone, got "
      + repr(pitch("agree") - pitch("plain")),
  )
  assert(
    near(pitch("clash"), pitch("plain") + 2 * pad),
    message: "rules that disagree should fall back to adding the gap, got "
      + repr(pitch("clash") - pitch("plain")),
  )
}
