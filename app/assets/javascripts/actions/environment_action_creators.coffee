@EnvironmentActionCreators =
  judgeMode: ->
    params = getQueryParams location.search
    AbilitysheetDispatcher.dispatch
      action: AbilitysheetConstants.JUDGE_MODE
      viewport: params.device isnt 'pc'
