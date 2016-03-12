message = 0

@MessageStore = new EventEmitter2()
$.extend MessageStore,
  emitChange: ->
    @emit AbilitysheetConstants.CHANGE_EVENT

  addChangeListener: (callback) ->
    @on AbilitysheetConstants.CHANGE_EVENT, callback

  removeChangeListener: (callback) ->
    @removeListener AbilitysheetConstants.CHANGE_EVENT, callback

  get: ->
    objectCopy message

MessageStore.dispatchToken = AbilitysheetDispatcher.register (payload) ->
  action = payload.action
  switch action
    when AbilitysheetConstants.FETCHED_MESSAGE_NUMBER
      message = payload.message
      MessageStore.emitChange()
