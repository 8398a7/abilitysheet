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
    objectCopy user

@UserStore.dispatchToken = AbilitysheetDispatcher.register (payload) ->
  action = payload.action
  switch action
    when AbilitysheetConstants.RECEIVED_CURRENT_USER
      user = if payload.user.current_user? then payload.user.current_user else {}
      UserStore.emitChange()
