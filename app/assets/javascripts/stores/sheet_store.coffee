sheets = {}

@SheetStore = new EventEmitter2()
$.extend SheetStore,
  emitChange: ->
    @emit AbilitysheetConstants.CHANGE_EVENT

  addChangeListener: (callback) ->
    @on AbilitysheetConstants.CHANGE_EVENT, callback

  removeChangeListener: (callback) ->
    @removeListener AbilitysheetConstants.CHANGE_EVENT, callback

  get: ->
    _.cloneDeep sheets

SheetStore.dispatchToken = AbilitysheetDispatcher.register (payload) ->
  action = payload.action
  switch action
    when AbilitysheetConstants.RECEIVED_SHEETS_DATA
      sheets = payload.sheets
      SheetStore.emitChange()
