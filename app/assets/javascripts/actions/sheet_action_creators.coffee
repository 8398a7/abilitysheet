class @SheetActionCreators
  @get: () ->
    SheetAPI.get (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.RECEIVED_SHEETS_DATA
        sheets: data
