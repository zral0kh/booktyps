// A cell spanning several rows takes its slots in every row it covers, so the
// cells after it are placed beside it rather than on top of it. This is a table
// that used to panic with "attempted to place a second cell".
#import "/tests/cases.typ": *
#show: setup

#table(
  columns: (auto, auto),
  table.header[Week][Date],
  table.cell(rowspan: 3)[1], [Mon, Sep 28], [Wed, Sep 30], [Fri, Oct 2],
  table.cell(rowspan: 3)[2], [Mon, Oct 5], [Wed, Oct 7], [Fri, Oct 9],
)
