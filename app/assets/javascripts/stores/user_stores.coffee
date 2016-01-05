user = {}

@UserStore = new EventEmitter2()
$.extend @UserStore,
  emitChange: ->
    @emit(AbilitysheetConstants.CHANGE_EVENT)

  addChangeListener: (callback) ->
    @on(AbilitysheetConstants.CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    @removeListener(AbilitysheetConstants.CHANGE_EVENT, callback)

  get: ->
    JSON.parse(JSON.stringify(user))

@UserStore.dispatchToken = AbilitysheetDispatcher.register (payload) ->
  action = payload.action
  switch action
    when AbilitysheetConstants.RECEIVED_CURRENT_USER
      if payload.user.current_user?
        user = payload.user.current_user
      else
        user = {}
      UserStore.emitChange()
