class @MessageAPI
  @fetch: (callback) ->
    option =
      type: 'GET'
      callback: callback
    AbilitysheetAPI.AjaxCall '/messages/number', option
