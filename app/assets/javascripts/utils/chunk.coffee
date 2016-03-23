Array::chunk = (n) ->
  len = Math.round(@length / n, 10)
  ret = []
  tmp = []
  for elem in @
    tmp.push elem
    if tmp.length is n
      ret.push tmp
      tmp = []
  ret.push tmp unless tmp.length is 0
  ret
