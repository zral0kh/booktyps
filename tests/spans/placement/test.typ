// Where each cell of a table with spans ends up, read off the laid-out table,
// which a reference image can only show. A span takes its slots in every row and
// column it covers, so the cells that follow sit beside it; a span is stretched
// over the blank tracks that rules add inside it; a cell that names its own `x`
// and `y` lands there and leaves the order of the others alone. `booktabs` is
// called here rather than shown, so that the table it returns can be inspected.
#import "/tests/cases.typ": *
#show: setup

// A cell spanning three rows: the dates sit beside it, down one column.
#context {
  let it = booktabs(table(
    columns: 2,
    table.header[Week][Date],
    table.cell(rowspan: 3)[1], [Mon], [Wed], [Fri],
    table.cell(rowspan: 3)[2], [Tue], [Thu], [Sat],
  ))
  assert(not overlaps(it), message: "two cells claim the same slot")

  let week = cell-of(it, [1])
  let mon = cell-of(it, [Mon])
  let wed = cell-of(it, [Wed])
  let fri = cell-of(it, [Fri])
  assert(mon.x > week.x, message: "the dates should sit beside the week")
  assert.eq((wed.x, fri.x), (mon.x, mon.x), message: "the dates share a column")
  assert.eq(week.y, mon.y, message: "the week starts where its first date does")
  assert.eq((wed.y, fri.y), (mon.y + 1, mon.y + 2), message: "no rule, no gap")
  assert.eq(week.rowspan, 3, message: "nothing was added inside the span")

  let next = cell-of(it, [2])
  assert.eq(next.y, fri.y + 1, message: "the second week follows the first")
  assert.eq(cell-of(it, [Tue]).y, next.y)
  assert(
    cell-of(it, [Week]).y < week.y and cell-of(it, [Date]).y < week.y,
    message: "the header comes first",
  )
}

// A rule inside the span adds blank rows, which the span has to cover or the
// dates after the rule would be beside nothing.
#context {
  let it = booktabs(table(
    columns: 2,
    table.cell(rowspan: 3)[1], [Mon], [Wed],
    table.hline(start: 1),
    [Fri],
  ))
  assert(not overlaps(it), message: "two cells claim the same slot")
  let week = cell-of(it, [1])
  let mon = cell-of(it, [Mon])
  let fri = cell-of(it, [Fri])
  assert(fri.y - mon.y > 2, message: "the rule should have added blank rows")
  assert.eq(
    week.rowspan, fri.y - week.y + 1,
    message: "the span should reach the last row it covers, the blank ones included",
  )
}

// The same across columns. A vertical rule thicker than the horizontal one it
// meets makes that one stop short, which opens blank columns around it, and a
// cell spanning the rule has to reach across them.
#context {
  let it = booktabs(table(
    columns: 3,
    table.vline(x: 1, stroke: 1.5pt),
    table.hline(y: 1),
    [a], [b], [c],
    table.cell(colspan: 2)[wide], [d],
  ))
  assert(not overlaps(it), message: "two cells claim the same slot")
  let wide = cell-of(it, [wide])
  let a = cell-of(it, [a])
  let b = cell-of(it, [b])
  assert(b.x - a.x > 1, message: "the rule should have added blank columns")
  assert.eq(wide.x, a.x)
  assert.eq(
    wide.colspan, b.x - a.x + 1,
    message: "the span should reach the last column it covers, the blank ones included",
  )
  assert.eq(cell-of(it, [d]).x, cell-of(it, [c]).x, message: "d is under c")
}

// A cell that names its place lands in it, and the cells around it keep to the
// order they were written in, taking the free slots one after another. Here
// that puts `i` in the third column of the third row, which the pinned cell
// leaves alone, and `j` and `k` in the row below, beside it.
#context {
  let it = booktabs(table(
    columns: 3,
    [a], [b], [c],
    [d], [e], [f],
    [g], [h], table.cell(x: 2, y: 3)[pinned],
    [i], [j], [k],
  ))
  assert(not overlaps(it), message: "two cells claim the same slot")
  let pinned = cell-of(it, [pinned])
  let (i, j, k) = ([i], [j], [k]).map(body => cell-of(it, body))
  assert.eq(pinned.x, cell-of(it, [c]).x, message: "pinned is in the third column")
  assert.eq(pinned.y, j.y, message: "pinned is in the fourth row, beside j and k")
  assert.eq((i.x, i.y), (cell-of(it, [c]).x, cell-of(it, [g]).y), message: "i fills the slot before")
  assert(j.x < k.x and k.x < pinned.x, message: "j and k come before it in the row")
  assert.eq(j.x, cell-of(it, [a]).x, message: "j starts the row")
}

// A header takes whole rows, whatever it does not fill. A row it leaves
// unfinished is left blank, and the body starts on the next one, not beside the
// last cell of the header.
#context {
  let it = booktabs(table(
    columns: 2,
    table.header[a],
    [c], [d], [e], [f],
  ))
  assert(not overlaps(it), message: "two cells claim the same slot")
  let (a, c, d) = ([a], [c], [d]).map(body => cell-of(it, body))
  assert(c.y > a.y, message: "c belongs to the body, below the header")
  assert.eq((c.x, d.x), (a.x, cell-of(it, [f]).x))
}

// And so does one with a span reaching past its last row: the body starts below
// what the span covers, not beside it.
#context {
  let it = booktabs(table(
    columns: 2,
    table.header([a], table.cell(rowspan: 2)[b]),
    [c], [d],
  ))
  assert(not overlaps(it), message: "two cells claim the same slot")
  let b = cell-of(it, [b])
  let c = cell-of(it, [c])
  assert(
    c.y >= b.y + b.rowspan,
    message: "c should start below the span, at row " + repr(c.y)
      + " against its end at " + repr(b.y + b.rowspan),
  )
}

// A header that follows a row left unfinished starts on a fresh row of its own,
// as the table places it, and does not take up the rest of that one.
#context {
  let it = booktabs(table(
    columns: 2,
    [x],
    table.header([a], [b]),
    [c], [d],
  ))
  assert(not overlaps(it), message: "two cells claim the same slot")
  let (x, a, b) = ([x], [a], [b]).map(body => cell-of(it, body))
  assert(a.y > x.y, message: "the header should start below the unfinished row")
  assert.eq((a.x, b.y), (x.x, a.y))
}
