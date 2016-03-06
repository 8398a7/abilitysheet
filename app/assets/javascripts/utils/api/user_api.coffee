@UserAPI =
  getMe: (callback) ->
    option =
      type: 'GET'
      callback: callback
    AbilitysheetAPI.AjaxCall '/users/me', option

  changeRival: (params, callback) ->
    option =
      type: 'PUT'
      callback: callback
    AbilitysheetAPI.AjaxCall "/users/change_rival/#{params.iidxid}", option
