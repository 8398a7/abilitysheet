@getQueryParams = (qs) ->
  qs = qs.split('+').join ' '

  params = {}
  re = /[?&]?([^=]+)=([^&]*)/g

  while tokens = re.exec(qs)
      params[decodeURIComponent(tokens[1])] = decodeURIComponent tokens[2]
  params

@mergeQueryParams = (url, params) ->
  count = 0
  for k, v of params
    if count is 0
      url += "?#{k}=#{v}"
      count++
      continue
    url += "&#{k}=#{v}"
  url
