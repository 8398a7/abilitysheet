statics = {}

@StaticStore = new EventEmitter2()
$.extend  StaticStore,
  emitChange: ->
    @emit AbilitysheetConstants.CHANGE_EVENT

  addChangeListener: (callback) ->
    @on AbilitysheetConstants.CHANGE_EVENT, callback

  removeChangeListener: (callback) ->
    @removeListener AbilitysheetConstants.CHANGE_EVENT, callback

  get: ->
    _.cloneDeep statics

StaticStore.dispatchToken = AbilitysheetDispatcher.register (payload) ->
  action = payload.action
  switch action
    when AbilitysheetConstants.RECEIVED_GRADE_DATA
      statics['grade'] = payload.data.grade
      statics['pref'] = payload.data.pref
      StaticStore.emitChange()
