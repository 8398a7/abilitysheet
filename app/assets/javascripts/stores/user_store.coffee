user = {}
targetUser = {}

@UserStore = new EventEmitter2()
UserStore.setMaxListeners 0

$.extend UserStore,
  emitChange: ->
    @emit(AbilitysheetConstants.CHANGE_EVENT)

  addChangeListener: (callback) ->
    @on(AbilitysheetConstants.CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    @removeListener(AbilitysheetConstants.CHANGE_EVENT, callback)

  get: ->
    objectCopy user

  getTargetUser: ->
    objectCopy targetUser

  renderAds: ->
    return true unless user.id?
    return false if user.role is 25 || user.role is 100
    true

UserStore.dispatchToken = AbilitysheetDispatcher.register (payload) ->
  action = payload.action
  switch action
    when AbilitysheetConstants.RECEIVED_CURRENT_USER
      user = if payload.user.current_user? then payload.user.current_user else {}
      UserStore.emitChange()

    when AbilitysheetConstants.CHANGE_RIVAL
      user = camelizeObject payload.users.current_user
      targetUser = camelizeObject payload.users.target_user
      UserStore.emitChange()
