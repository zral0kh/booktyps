// A table may carry a label of its own, to be found by a query, aimed at by a
// show rule, or referred to through a figure. `booktabs` rebuilds the table, and
// a label is not an argument of one, so it must not be handed on to it as such.
// Nor is it put back on the result: the label stays with the element being shown,
// so a query finds the table once, and one put on the result as well would find
// it twice. A show rule on the label, set after the `booktabs` rule, applies to
// the table once. `booktabs` is called directly where it is the table that is
// inspected.
#import "/tests/cases.typ": *
#show: setup
#show <late>: it => [#metadata("late")<hit>#it]

#let sample() = table(columns: 2, table.header([a], [b]), [c], [d])

// Called directly on a table with a label.
#context {
  let it = booktabs([#sample()<direct>])
  assert.eq(it.func(), table, message: "a labelled table should come back as a table")
  assert(lines-of(it, table.hline).len() > 0, message: "and with its rules drawn")
}

// Through the show rule, found again by its label, and by a figure's.
#sample() <mine>

#figure(sample(), caption: [A table.]) <fig>

See @fig.

#sample() <late>

#context {
  assert.eq(query(<mine>).len(), 1, message: "the labelled table should be found once")
  assert.eq(query(<fig>).len(), 1, message: "and so should the figure around one")
  assert.eq(
    query(<hit>).map(hit => hit.value), ("late",),
    message: "a rule on the label, set after the table rule, should apply once",
  )
}
