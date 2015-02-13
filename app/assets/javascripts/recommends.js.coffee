$.extend $.fn.DataTable.ext.oSort,
  'custom': (a) ->
    a
  'custom-asc': (x, y) ->
    x = parseFloat(x)
    y = parseFloat(y)
    if x < y then -1 else if x > y then 1 else 0
  'custom-desc': (x, y) ->
    x = parseFloat(x)
    y = parseFloat(y)
    if x < y then 1 else if x > y then -1 else 0
