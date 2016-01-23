@AbilitysheetAPI =
  server: location.protocol + '//' + location.host
  apiPath: '/api/v1'

  AjaxCall: (api, option = null) ->
    option = {}         unless option?
    option.type = 'GET' unless option.type?
    option.params = {}  unless option.params?

    $.ajax
      type: option.type
      xhrFields:
        withCredentials: true
      url: AbilitysheetAPI.server + AbilitysheetAPI.apiPath + api
      data: option.params
    .done (result, type) ->
      option.callback result if option.callback?
    .fail (XMLHttpRequest, textStatus, errorThrown) ->
      if XMLHttpRequest.status == 502
        if $('.uk-notify-message').length is 0
          UIkit.notify
            message: "サーバの調子が悪いようです。そのまましばらくお待ち下さい。"
            status: 'danger'
            timeout: 5000
        setTimeout ->
          AbilitysheetAPI.AjaxCall(api, option)
        , 10000
      else
        if $('.uk-notify-message').length is 0
          UIkit.notify
            message: "サーバの調子が悪いようです。しばらく時間を置いてからアクセスしなおすか、そのままお待ち下さい。"
            status: 'danger'
            timeout: 5000
