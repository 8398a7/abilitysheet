@ScoreActionCreators =
  get: (params) ->
    ScoreAPI.get params, (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.RECEIVED_SCORE_DATA
        scores: data

  update: (params) ->
    ScoreAPI.update params, (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.UPDATED_SCORE_DATA
        score: data

  show: (state) ->
    AbilitysheetDispatcher.dispatch
      action: AbilitysheetConstants.SHOW_SCORE_DATA
      state: state

  hide: (state) ->
    AbilitysheetDispatcher.dispatch
      action: AbilitysheetConstants.HIDE_SCORE_DATA
      state: state
