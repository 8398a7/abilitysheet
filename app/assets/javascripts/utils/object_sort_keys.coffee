Object.sortedKeys = (obj, key, order = 'asc') ->
  if order is 'asc'
    return Object.keys(obj).sort (a, b) => if obj[a][key] < obj[b][key] then -1 else if obj[a][key] > obj[b][key] then 1 else 0
  else
    return Object.keys(obj).sort (a, b) => if obj[a][key] > obj[b][key] then -1 else if obj[a][key] < obj[b][key] then 1 else 0
