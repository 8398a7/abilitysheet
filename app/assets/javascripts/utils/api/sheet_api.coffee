@SheetAPI =
  get: (callback) ->
    option =
      type: 'GET'
      callback: callback
    AbilitysheetAPI.AjaxCall "/sheets", option
