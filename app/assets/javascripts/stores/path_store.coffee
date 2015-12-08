paths = {}

@PathStore = new EventEmitter2()
$.extend @PathStore,
  emitChange: ->
    @emit(AbilitysheetConstants.CHANGE_EVENT)

  addChangeListener: (callback) ->
    @on(AbilitysheetConstants.CHANGE_EVENT, callback)

  all: ->
    paths

@PathStore.dispatchToken = AbilitysheetDispatcher.register (payload) ->
  action = payload.action

  switch action
    when AbilitysheetConstants.RECEIVED_NAVBAR
      console.log 'navbar'
      PathStore.emitChange()
