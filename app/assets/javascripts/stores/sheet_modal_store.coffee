sheets = {}

@SheetModalStore = new EventEmitter2()
$.extend SheetModalStore,
  emitChange: ->
    @emit AbilitysheetConstants.CHANGE_EVENT

  addChangeListener: (callback) ->
    @on AbilitysheetConstants.CHANGE_EVENT, callback

  removeChangeListener: (callback) ->
    @removeListener AbilitysheetConstants.CHANGE_EVENT, callback

  get: ->
    _.cloneDeep sheets

SheetModalStore.dispatchToken = AbilitysheetDispatcher.register (payload) ->
  action = payload.action
  switch action
    when AbilitysheetConstants.RECEIVED_SHEET_MODAL_DATA
      sheets = payload.sheets
      SheetModalStore.emitChange()
