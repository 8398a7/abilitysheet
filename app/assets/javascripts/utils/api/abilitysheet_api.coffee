class @AbilitysheetAPI
  @server = location.protocol + '//' + location.host
  @apiPath = "#{Routes.root_path().split('/')[1]}/api/v1"

  @AjaxCall: (api, option = null) ->
    option = {}         unless option?
    option.type = "GET" unless option.type?
    option.params = {}  unless option.params?

    self = @
    $.ajax
      type: option.type
      xhrFields:
        withCredentials: true
      url: AbilitysheetAPI.server + AbilitysheetAPI.apiPath + api
      data: option.params

      success: (result, type) ->
        if option.callback?
          option.callback result

      error: (XMLHttpRequest, textStatus, errorThrown) ->
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
