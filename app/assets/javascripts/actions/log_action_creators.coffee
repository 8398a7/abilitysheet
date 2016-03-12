@LogActionCreators =
  get: (params) ->
    LogAPI.get params, (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.RECEIVED_LOG_DATA
        logs: data
