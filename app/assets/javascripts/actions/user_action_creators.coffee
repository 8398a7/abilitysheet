class @UserActionCreators
  @getMe: ->
    UserAPI.getMe (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.RECEIVED_CURRENT_USER
        user: data
