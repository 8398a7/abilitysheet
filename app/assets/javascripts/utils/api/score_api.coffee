@ScoreAPI =
  get: (params, callback) ->
    option =
      type: 'GET'
      callback: callback
    AbilitysheetAPI.AjaxCall "/scores/#{params.iidxid}", option

  update: (params, callback) ->
    option =
      type: 'PUT'
      callback: callback
    AbilitysheetAPI.AjaxCall "/scores/#{params.iidxid}/#{params.sheetId}/#{params.state}", option

  getModal: (params, callback) ->
    option =
      type: 'GET'
      callback: callback
    AbilitysheetAPI.AjaxCall "/scores/#{params.iidxid}/#{params.sheetId}", option
