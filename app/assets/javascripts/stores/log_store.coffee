logs = {}

@LogStore = new EventEmitter2()
$.extend @LogStore,
  emitChange: ->
    @emit(AbilitysheetConstants.CHANGE_EVENT)

  addChangeListener: (callback) ->
    @on(AbilitysheetConstants.CHANGE_EVENT, callback)

  removeChangeListener: (callback) ->
    @removeListener(AbilitysheetConstants.CHANGE_EVENT, callback)

  get: ->
    objectCopy logs

@LogStore.dispatchToken = AbilitysheetDispatcher.register (payload) ->
  action = payload.action
  switch action
    when AbilitysheetConstants.RECEIVED_LOG_DATA
      for log in payload.logs
        logs[log.created_date] ||= []
        continue unless logs[log.created_date].indexOf(log.title) is -1
        logs[log.created_date].push log.title
      LogStore.emitChange()
