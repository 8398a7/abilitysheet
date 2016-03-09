@GraphAPI =
  get: (params, callback) ->
    option =
      type: 'GET'
      callback: callback
    AbilitysheetAPI.AjaxCall "/logs/graph/#{params.iidxid}/#{params.year}/#{params.month}", option
