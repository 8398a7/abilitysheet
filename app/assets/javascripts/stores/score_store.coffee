scores = {}

@ScoreStore = new EventEmitter2()
$.extend ScoreStore,
  emitChange: ->
    @emit AbilitysheetConstants.CHANGE_EVENT

  addChangeListener: (callback) ->
    @on AbilitysheetConstants.CHANGE_EVENT, callback

  removeChangeListener: (callback) ->
    @removeListener AbilitysheetConstants.CHANGE_EVENT, callback

  get: ->
    objectCopy scores

setScore = (score) ->
  sheetId = score.sheet_id
  delete score.sheet_id
  scores[sheetId] ||= {}
  score.color = Env.color[score.state]
  score.display = ''
  score.sheetId = sheetId
  scores[sheetId] = score

ScoreStore.dispatchToken = AbilitysheetDispatcher.register (payload) ->
  action = payload.action
  switch action
    when AbilitysheetConstants.RECEIVED_SCORE_DATA
      setScore score for score in payload.scores
      ScoreStore.emitChange()
    when AbilitysheetConstants.UPDATED_SCORE_DATA
      setScore payload.score
      ScoreStore.emitChange()
    when AbilitysheetConstants.SHOW_SCORE_DATA
      for id, score of scores
        continue unless score.state is payload.state
        scores[id].display = ''
      ScoreStore.emitChange()
    when AbilitysheetConstants.HIDE_SCORE_DATA
      for id, score of scores
        continue unless score.state is payload.state
        scores[id].display = 'none'
      ScoreStore.emitChange()
    when AbilitysheetConstants.SHOW_SHEET_DATA
      for id, sheet of SheetStore.get()
        continue unless sheet.version is payload.version
        scores[id].display = ''
      ScoreStore.emitChange()
    when AbilitysheetConstants.HIDE_SHEET_DATA
      for id, sheet of SheetStore.get()
        continue unless sheet.version is payload.version
        scores[id].display = 'none'
      ScoreStore.emitChange()
