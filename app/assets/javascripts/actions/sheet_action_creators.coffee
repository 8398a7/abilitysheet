@SheetActionCreators =
  get: ->
    return null if SheetStore.get()[1]
    SheetAPI.get (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.RECEIVED_SHEETS_DATA
        sheets: data

  show: (version) ->
    AbilitysheetDispatcher.dispatch
      action: AbilitysheetConstants.SHOW_SHEET_DATA
      version: version

  hide: (version) ->
    AbilitysheetDispatcher.dispatch
      action: AbilitysheetConstants.HIDE_SHEET_DATA
      version: version
