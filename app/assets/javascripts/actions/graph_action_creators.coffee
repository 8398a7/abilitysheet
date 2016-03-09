class @GraphActionCreators
  @get: (params) ->
    GraphAPI.get params, (data) ->
      AbilitysheetDispatcher.dispatch
        action: AbilitysheetConstants.RECEIVED_GRAPH_DATA
        graph: data
