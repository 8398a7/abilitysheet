environments =
  viewport: true
  reverseSheet: false

@EnvironmentStore = new EventEmitter2()
$.extend EnvironmentStore,
  emitChange: ->
    @emit AbilitysheetConstants.CHANGE_EVENT

  addChangeListener: (callback) ->
    @on AbilitysheetConstants.CHANGE_EVENT, callback

  removeChangeListener: (callback) ->
    @removeListener AbilitysheetConstants.CHANGE_EVENT, callback

  findBy: (key) ->
    objectCopy environments[key]

EnvironmentStore.dispatchToken = AbilitysheetDispatcher.register (payload) ->
  action = payload.action
  switch action
    when AbilitysheetConstants.JUDGE_MODE
      environments['viewport'] = payload.viewport
      EnvironmentStore.emitChange()
    when AbilitysheetConstants.JUDGE_REVERSE
      environments['reverseSheet'] = payload.reverseSheet
      EnvironmentStore.emitChange()
