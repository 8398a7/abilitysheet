class @StaticActionCreators
  @get: ->
    return if StaticStore.get().grade?
    StaticAPI.get (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.RECEIVED_GRADE_DATA
        data: data
