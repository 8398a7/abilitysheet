class @UserActionCreators
  @getMe: ->
    return if UserStore.get().id?
    UserAPI.getMe (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.RECEIVED_CURRENT_USER
        user: data
