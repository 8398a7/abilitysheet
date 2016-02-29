@LogAPI =
  get: (params, callback) ->
    option =
      type: 'GET'
      callback: callback
    AbilitysheetAPI.AjaxCall "/logs/#{params.iidxid}/#{params.year}/#{params.month}", option
