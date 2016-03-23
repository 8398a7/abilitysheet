@MessageActionCreators =
  fetch: ->
    MessageAPI.fetch (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.FETCHED_MESSAGE_NUMBER
        message: data.num
