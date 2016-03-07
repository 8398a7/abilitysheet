@MessageAPI =
  fetch: (callback) ->
    option =
      type: 'GET'
      callback: callback
    AbilitysheetAPI.AjaxCall '/messages', option
