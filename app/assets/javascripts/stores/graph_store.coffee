graph = {}

@GraphStore = new EventEmitter2()
$.extend GraphStore,
  emitChange: ->
    @emit AbilitysheetConstants.CHANGE_EVENT

  addChangeListener: (callback) ->
    @on AbilitysheetConstants.CHANGE_EVENT, callback

  removeChangeListener: (callback) ->
    @removeListener AbilitysheetConstants.CHANGE_EVENT, callback

  get: ->
    objectCopy graph

GraphStore.dispatchToken = AbilitysheetDispatcher.register (payload) ->
  action = payload.action
  switch action
    when AbilitysheetConstants.RECEIVED_GRAPH_DATA
      graph = payload.graph
      GraphStore.emitChange()
