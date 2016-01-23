@UserAPI =
  getMe: (callback) ->
    option =
      type: 'GET'
      callback: callback
    AbilitysheetAPI.AjaxCall '/users/me', option
