@StaticAPI =
  get: (callback) ->
    option =
      type: 'GET'
      callback: callback
    AbilitysheetAPI.AjaxCall '/statics', option
