// A fill given as a function meets the blank space the rules add. The air
// above the first row and below the last has only the one cell beside it, and
// takes its fill, so a shaded header runs up to the heavy rule. The air between
// two rows takes a fill only where the cells either side agree: a banded fill
// stops short of a rule rather than running past it, and a shaded column runs
// straight through.
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: 3,
  fill: (x, y) => if y == 0 { luma(215) } else if x == 1 { rgb("#fee") }
    else if calc.even(y) { luma(240) },
  table.header(..head),
  ..rows.slice(0, 3),
  table.hline(),
  ..rows.slice(3),
  table.footer(..foot),
)
