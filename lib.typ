// =============================================================================
//  booktyps, the booktabs look for Typst tables. Also handles breaking vlines
//  and uses native typst syntax.
//
//  `#show table: booktabs` is the whole setup. The rules are read off the
//  table's own structure, so nothing has to be written into the table by hand:
//  a heavy rule above and below it, and a light one under `table.header` and
//  above `table.footer`. A table with neither gets just the two heavy rules.
//
//  Where two rules meet, one gives way and stops short of the other. By
//  default the thinner one gives way, which is what lets a sideways table built
//  out of plain `table.hline` and `table.vline` keep the same look.
// =============================================================================

/// How many columns a table has, given as a count or a list of track sizes.
#let _column-count(columns) = if type(columns) == int {
  columns
} else if type(columns) == array { columns.len() } else { 1 }

/// An element's settable arguments, without the ones named.
#let _options(element, ..without) = {
  let options = element.fields()
  for name in without.pos() { let _ = options.remove(name, default: none) }
  options
}

/// Spell an inset out as all four sides.
///
/// Takes a single value for every side, or a dictionary keyed by `x` and `y`,
/// or by the sides themselves, which win where both are given.
#let _sides(value) = if type(value) == dictionary {
  let x = value.at("x", default: 0pt)
  let y = value.at("y", default: 0pt)
  (
    top: value.at("top", default: y),
    bottom: value.at("bottom", default: y),
    left: value.at("left", default: x),
    right: value.at("right", default: x),
  )
} else {
  (top: value, bottom: value, left: value, right: value)
}

/// How thick a stroke draws, for deciding which of two rules wins.
#let _thickness(value) = {
  let width = stroke(value).thickness
  if width == auto { 1pt } else { width }
}

/// Read a table's cells, rules, header and footer in one pass over its children.
///
/// Returns the cells as `(column, row, body)`, the rules the author placed with
/// the element each came from, the row the header ends before and the row the
/// footer starts at, each with that part's own arguments so that `repeat` and
/// the like survive, and the number of rows.
#let _read-table(it, ncols) = {
  let cells = ()
  let hlines = ()
  let vlines = ()
  let header = none
  let footer = none
  let column = 0
  let row = 0

  for child in it.children {
    let part = child.func()
    let grouped = part in (table.header, table.footer)
    let first-row = row

    for cell in if grouped { child.children } else { (child,) } {
      if cell.func() == table.hline {
        let rule = cell.fields()
        hlines.push((
          at: rule.at("y", default: row),
          start: rule.at("start", default: 0),
          end: rule.at("end", default: none),
          stroke: rule.at("stroke", default: auto),
          element: cell,
        ))
      } else if cell.func() == table.vline {
        let rule = cell.fields()
        vlines.push((
          at: rule.at("x", default: column),
          start: rule.at("start", default: 0),
          end: rule.at("end", default: none),
          stroke: rule.at("stroke", default: auto),
          element: cell,
        ))
      } else {
        cells.push((column: column, row: row, body: cell))
        column += if cell.func() == table.cell {
          cell.fields().at("colspan", default: 1)
        } else { 1 }
        while column >= ncols { column -= ncols; row += 1 }
      }
    }

    if part == table.header {
      header = (end: row, options: _options(child, "children"))
    }
    if part == table.footer {
      footer = (start: first-row, options: _options(child, "children"))
    }
  }

  (
    cells: cells,
    hlines: hlines,
    vlines: vlines,
    header: header,
    footer: footer,
    rows: row + if column > 0 { 1 } else { 0 },
  )
}

/// Plan one axis of the grid as it will actually be laid out.
///
/// A rule that has to be stopped short of gets blank tracks beside it, sized
/// `before` and `after`. That is the only way to interrupt a rule at all: a
/// cell stroke always spans its whole cell, so a rule can stop short of
/// another only if some track in between carries no rule.
///
/// `boundaries` maps each authored boundary that carries a rule to whether it
/// needs those blank tracks and how much air it wants on each side, since the
/// air may be given per rule. Returns one entry per laid-out track, an authored
/// index or the size of a blank one; where each rule ends up, keyed by the
/// track whose leading edge draws it; which rule every blank track belongs to,
/// since a rule has one on each side and a crossing rule must run through both;
/// the boundary drawn on the very last trailing edge, if any; and that index.
#let _plan-axis(boundaries, count) = {
  let tracks = ()
  let rule-track = (:)
  let belongs = (:)
  let trailing = none

  for boundary in range(count + 1) {
    let rule = boundaries.at(str(boundary), default: none)
    if rule != none {
      if rule.spaced {
        if boundary > 0 {
          belongs.insert(str(tracks.len()), boundary)
          tracks.push(rule.before)
        }
        if boundary < count {
          rule-track.insert(str(tracks.len()), boundary)
          belongs.insert(str(tracks.len()), boundary)
          tracks.push(rule.after)
        } else { trailing = boundary }
      } else if boundary < count {
        rule-track.insert(str(tracks.len()), boundary)
      } else { trailing = boundary }
    }
    if boundary < count { tracks.push(boundary) }
  }

  (
    tracks: tracks,
    rule-track: rule-track,
    belongs: belongs,
    trailing: trailing,
    last: tracks.len() - 1,
  )
}

/// Give a table the booktabs look.
///
/// Apply it once and then write plain tables; the rules follow from the
/// structure. A heavy rule goes above and below the table, a light one under a
/// `table.header` and above a `table.footer`. A table with neither gets only
/// the two heavy ones.
///
/// Placing a `table.hline` adds a light rule of your own, and `start` and `end`
/// narrow it to some columns, the way booktabs' `\cmidrule` does. A
/// `table.vline` runs down the table the same way. Where two rules meet, one
/// gives way and stops short of the other, which is the part plain `table`
/// strokes cannot express; `break-rule` names the one that gives way. A header or a
/// footer keeps its own arguments, so whether it repeats across a page break
/// stays `table.header(repeat: ..)`, as usual.
/// 
/// No inset is applied so write your own. The booktabs default inset is `2.7pt`.
///
/// Example:
/// ```typ
/// #import "@preview/booktyps:0.1.0": booktabs
/// #show table: booktabs.with(heavy: 1.3pt)
///
/// #table(
///   columns: 3,
///   align: (left, center, right),
///   table.vline(x: 1),
///   table.header([*Language*], [*Typed*], [*Year*]),
///   [Typst], [yes], [2019],
///   [TeX],   [no],  [1978],
///   table.hline(start: 1),
///   [Lout],  [no],  [1991],
///   table.footer([*Total*], [], [3]),
/// )
/// ```
///
/// A table laid out sideways has no header to read a rule off, so draw the
/// rules yourself and let the thinner ones give way:
///
/// ```typ
/// #table(
///   columns: 4,
///   table.vline(x: 1, stroke: 0.9pt),
///   table.hline(y: 1, stroke: 0.4pt),
///   [*Language*], [Typst], [TeX],  [Lout],
///   [*Year*],     [2019],  [1978], [1991],
/// )
/// ```
///
/// - heavy (stroke): The rule above and below the table, booktabs' `\toprule`
///   and `\bottomrule`. Default is `0.9pt`. 
///   Set this to `0pt` if you are writing horizontal tables.
///
/// - light (stroke): The rule under a header, above a footer, and for a
///   `table.hline` that sets no stroke of its own, booktabs' `\midrule`.
///   Default is `0.5pt`.
///
/// - vertical (stroke): The rule for a `table.vline` that sets no stroke of its
///   own. Default is `0.4pt`.
///
/// - rule-inset (length, dictionary, function): How far a rule is held away
///   from what it divides, booktabs' `\aboverulesep`, and equally how far a
///   rule that loses a crossing stops short of the one that wins. Takes one
///   value for every side, or a dictionary keyed by `x` and `y`, or by `top`,
///   `bottom`, `left` and `right`. Default is `2.7pt`. \
///   It also takes a function, `(x, y, rule)=>{..}`, 
///   giving each rule its own air. 
///   One of `x` and `y` is always `none`: a
///   horizontal rule has no column, a vertical one no row. `rule` is the rule
///   itself, so it can be read for its stroke. Return whatever the parameter
///   takes otherwise, and it applies to that rule alone. \
///   Breaking a rule therefore costs room: the gap has to come from somewhere,
///   so a table whose vertical rule runs through is wider by `left` plus
///   `right` at that rule, just as every horizontal rule makes the table taller
///   by `top` plus `bottom`. LaTeX's booktabs does the same. Only a vertical
///   rule that something gives way to is spaced, so one that never wins a
///   crossing costs nothing.
///
/// - break-rule (auto, function): Which of two rules is to break under the other. `auto` breaks the thinner one, and if both are equal the vertical one. Pass `table.hline` or
///   `table.vline` to always break that one, or a function
///   `(x, y, hl, vl)` taking the column and row the two meet at and the two
///   instantiated rules themselves, and returning `table.hline` or `table.vline`. 
///   Default is `auto`. 
///
/// - it (content): The table to restyle, handed over by the show rule.
///
/// -> content
#let booktabs(
  heavy: 0.9pt,
  light: 0.5pt,
  vertical: 0.4pt,
  rule-inset: 2.7pt,
  break-rule: auto,
  it,
) = {
  assert( it.func() == table, 
    message: "The booktabs rule may only be applied to tables: `show table: booktabs`."
  )
  // Already transformed: the stroke is only ever a function once we made it one.
  if type(it.stroke) == function { return it }

  // The air around a rule may be given per rule, so it is resolved for each.
  let air-of(rule, x, y) = _sides(if type(rule-inset) == function {
    rule-inset(x, y, rule.element)
  } else { rule-inset })
  let ncols = _column-count(it.columns)
  let content = _read-table(it, ncols)
  let nrows = content.rows
  let header-end = if content.header == none { none } else { content.header.end }
  let footer-start = if content.footer == none { none } else { content.footer.start }

  // Every horizontal rule, the ones read off the table's structure together
  // with the ones the author placed, which win where both fall on a boundary.
  let structural(at, stroke) = (
    at: at,
    start: 0,
    end: ncols,
    stroke: stroke,
    element: table.hline(y: at, stroke: stroke),
  )
  let from-structure = (structural(0, heavy), structural(nrows, heavy))
  if header-end != none and 0 < header-end and header-end < nrows {
    from-structure.push(structural(header-end, light))
  }
  if footer-start != none and 0 < footer-start and footer-start < nrows {
    from-structure.push(structural(footer-start, light))
  }

  let hrules = (:)
  for rule in from-structure { hrules.insert(str(rule.at), rule) }
  for rule in content.hlines {
    hrules.insert(str(rule.at), (
      ..rule,
      end: if rule.end == none { ncols } else { rule.end },
      stroke: if rule.stroke == auto { light } else { rule.stroke },
    ))
  }

  let vrules = (:)
  for rule in content.vlines {
    vrules.insert(str(rule.at), (
      ..rule,
      end: if rule.end == none { nrows } else { rule.end },
      stroke: if rule.stroke == auto { vertical } else { rule.stroke },
    ))
  }

  // Two rules cross only where each reaches past the other; meeting end to end
  // is not a crossing and needs no decision.
  let crosses(hrule, vrule) = (
    hrule.start < vrule.at
      and vrule.at < hrule.end
      and vrule.start < hrule.at
      and hrule.at < vrule.end
  )
  /// Which of two crossing rules is the one broken; the other runs through.
  let broken(hrule, vrule) = {
    if break-rule == table.hline or break-rule == table.vline {
      break-rule
    } else if break-rule == auto {
      // The thinner rule gives way, the horizontal one where they are equal.
      if _thickness(vrule.stroke) <= _thickness(hrule.stroke) { table.vline } else { table.hline }
    } else {
      break-rule(vrule.at, hrule.at, hrule.element, vrule.element)
    }
  }

  // A horizontal rule always gets its air, because booktabs sets one apart from
  // the rows it divides whether or not anything crosses it. A vertical rule
  // only needs air where it actually wins a crossing, and giving it any would
  // widen the table, so it is only spaced where it has to be.
  // Each rule keeps the air on its own sides: a horizontal rule's top and
  // bottom, a vertical one's left and right. That air is what a crossing rule
  // stops short by, so the gap a broken rule leaves is `rule-inset` either way.
  let hline-spaced = (:)
  for (at, hrule) in hrules {
    let air = air-of(hrule, none, hrule.at)
    hline-spaced.insert(at, (spaced: true, before: air.top, after: air.bottom))
  }
  let vline-spaced = (:)
  for (at, vrule) in vrules {
    let air = air-of(vrule, vrule.at, none)
    vline-spaced.insert(at, (
      // A vertical rule only needs room where something actually gives way to
      // it; one that never wins a crossing costs the table no width.
      spaced: hrules.values().any(hrule => (
        crosses(hrule, vrule) and broken(hrule, vrule) == table.hline
      )),
      before: air.left,
      after: air.right,
    ))
  }

  let rows-plan = _plan-axis(hline-spaced, nrows)
  let cols-plan = _plan-axis(vline-spaced, ncols)

  // Where each authored row and column ended up, so the cells and the rules can
  // be placed against the laid-out grid rather than the authored one.
  let placed(plan) = {
    let by-index = (:)
    for (index, track) in plan.tracks.enumerate() {
      if type(track) == int { by-index.insert(str(track), index) }
    }
    by-index
  }
  let placed-row = placed(rows-plan)
  let placed-col = placed(cols-plan)


  let hrule-at(index) = hrules.at(
    str(rows-plan.rule-track.at(str(index), default: -1)),
    default: none,
  )
  let vrule-at(index) = vrules.at(
    str(cols-plan.rule-track.at(str(index), default: -1)),
    default: none,
  )
  // Which rule a blank track sits beside, for deciding whether a crossing rule
  // runs through it. Both of a rule's blank tracks answer with that rule.
  let hrule-beside(index) = hrules.at(
    str(rows-plan.belongs.at(str(index), default: -1)),
    default: none,
  )
  let vrule-beside(index) = vrules.at(
    str(cols-plan.belongs.at(str(index), default: -1)),
    default: none,
  )

  let horizontal(hrule, x) = if hrule != none {
    let track = cols-plan.tracks.at(x)
    let through = if type(track) == int {
      hrule.start <= track and track < hrule.end
    } else {
      let vrule = vrule-beside(x)
      vrule != none and crosses(hrule, vrule) and broken(hrule, vrule) != table.hline
    }
    if through { hrule.stroke }
  }
  let vertical-at(vrule, y) = if vrule != none {
    let track = rows-plan.tracks.at(y)
    let through = if type(track) == int {
      vrule.start <= track and track < vrule.end
    } else {
      let hrule = hrule-beside(y)
      hrule != none and crosses(hrule, vrule) and broken(hrule, vrule) != table.vline
    }
    if through { vrule.stroke }
  }

  let place-cell(cell) = table.cell(
    x: placed-col.at(str(cell.column)),
    y: placed-row.at(str(cell.row)),
    .._options(cell.body, "x", "y", "body"),
    if cell.body.func() == table.cell { cell.body.body } else { cell.body },
  )

  // A header and a footer take their own rules with them when they repeat, so
  // each reaches as far as the blank tracks around its rule. Those tracks hold
  // no cell of their own, so they need one to belong to either. A blank track
  // is the gap itself, so it takes none of the table's padding.
  let spacer-anchor(row) = table.cell(x: 0, y: row, inset: 0pt, [])
  let anchors(rows) = rows
    .filter(row => type(rows-plan.tracks.at(row)) != int)
    .map(spacer-anchor)
  let head-until = if header-end == none { 0 } else {
    placed-row.at(str(header-end), default: rows-plan.tracks.len())
  }
  let foot-from = if footer-start == none { rows-plan.tracks.len() } else {
    let first = placed-row.at(str(footer-start))
    while first > 0 and type(rows-plan.tracks.at(first - 1)) != int { first -= 1 }
    first
  }
  let placed-at(cell) = placed-row.at(str(cell.row))

  let part(wrap, options, rows, cells) = if cells.len() == 0 { () } else {
    (wrap(..options, ..anchors(rows), ..cells.map(place-cell)),)
  }
  let sizes(plan) = plan.tracks.map(track => if type(track) == int { auto } else { track })

  table(
    rows: sizes(rows-plan),
    columns: sizes(cols-plan).enumerate().map(((index, size)) => if size != auto {
      size
    } else if type(it.columns) == array {
      it.columns.at(cols-plan.tracks.at(index))
    } else { auto }),
    stroke: (x, y) => (
      top: horizontal(hrule-at(y), x),
      bottom: if y == rows-plan.last and rows-plan.trailing != none {
        horizontal(hrules.at(str(rows-plan.trailing)), x)
      },
      left: vertical-at(vrule-at(x), y),
      right: if x == cols-plan.last and cols-plan.trailing != none {
        vertical-at(vrules.at(str(cols-plan.trailing)), y)
      },
    ),
    .._options(it, "children", "stroke", "rows", "columns", "row-gutter"),
    ..part(
      table.header,
      if content.header == none { (:) } else { content.header.options },
      range(head-until),
      content.cells.filter(cell => placed-at(cell) < head-until),
    ),
    ..content
      .cells
      .filter(cell => head-until <= placed-at(cell) and placed-at(cell) < foot-from)
      .map(place-cell),
    ..part(
      table.footer,
      if content.footer == none { (:) } else { content.footer.options },
      range(foot-from, rows-plan.tracks.len()),
      content.cells.filter(cell => placed-at(cell) >= foot-from),
    ),
  )
}
