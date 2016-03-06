class @UserActionCreators
  @getMe: ->
    return if UserStore.get().id?
    UserAPI.getMe (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.RECEIVED_CURRENT_USER
        user: data

  @changeRival: (iidxid) ->
    UserAPI.changeRival iidxid: iidxid, (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.CHANGE_RIVAL
        users: data
