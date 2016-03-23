@SheetModalActionCreators =
  get: (params) ->
    ScoreAPI.getModal params, (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.RECEIVED_SHEET_MODAL_DATA
        sheets: data
