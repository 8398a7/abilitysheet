@EnvironmentActionCreators =
  judgeMode: ->
    params = getQueryParams location.search
    AbilitysheetDispatcher.dispatch
      action: AbilitysheetConstants.JUDGE_MODE
      viewport: params.device isnt 'pc'

  judgeReverse: ->
    params = getQueryParams location.search
    AbilitysheetDispatcher.dispatch
      action: AbilitysheetConstants.JUDGE_REVERSE
      reverseSheet: params.reverse_sheet is 'true'

  changeReverse: (reverse) ->
    AbilitysheetDispatcher.dispatch
      action: AbilitysheetConstants.JUDGE_REVERSE
      reverseSheet: reverse
