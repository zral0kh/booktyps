// A rule's stroke may be given any way Typst allows. Only its thickness decides
// which of two crossing rules gives way; the paint is carried through untouched.
// A rule with no stroke is not a rule at all: it draws nothing and takes no air.
#import "/tests/cases.typ": *
#show: setup

#let rows(tag) = (
  [#metadata(none)#label(tag + "-0")a], [b],
  [#metadata(none)#label(tag + "-1")a], [b],
)

#table(columns: 2, ..rows("plain"))
#table(columns: 2,
  rows("blank").at(0), rows("blank").at(1),
  table.hline(stroke: none),
  rows("blank").at(2), rows("blank").at(3),
)
#table(columns: 2,
  rows("ruled").at(0), rows("ruled").at(1),
  table.hline(),
  rows("ruled").at(2), rows("ruled").at(3),
)

#context {
  let y(tag, i) = query(label(tag + "-" + str(i))).first().location().position().y
  let pitch(tag) = y(tag, 1) - y(tag, 0)
  let near(a, b) = calc.abs((a - b).pt()) < 0.01

  assert(
    near(pitch("blank"), pitch("plain")),
    message: "a rule with no stroke should take no air, got "
      + repr(pitch("blank") - pitch("plain")) + " more than a bare table",
  )
  assert(
    pitch("ruled") > pitch("plain"),
    message: "a rule with a stroke should still take its air",
  )

  // The paint survives, and thickness alone settles a crossing.
  let it = booktabs(table(columns: 3,
    table.vline(x: 1, stroke: 1.2pt + blue),
    table.hline(y: 1, stroke: 0.6pt + red),
    [a], [b], [c], [a], [b], [c],
  ))
  let strokes = ()
  for x in range(it.columns.len()) {
    for yy in range(it.rows.len()) {
      let cell = (it.stroke)(x, yy)
      for side in ("top", "left") {
        let s = cell.at(side)
        if s != none { strokes.push(stroke(s).paint) }
      }
    }
  }
  assert(blue in strokes, message: "the vertical rule should keep its paint")
  assert(red in strokes, message: "the horizontal rule should keep its paint")
}
