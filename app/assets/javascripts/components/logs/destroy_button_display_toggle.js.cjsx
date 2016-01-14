class @DestroyButtonDisplayToggle extends React.Component
  constructor: ->
    @state =
      nonDisplay: true
      display: false

  toggleDisplay: (type) ->
    $('.destroy-button').each (index, elem) ->
      if type is 'display' then $(elem).show() else $(elem).hide()


  onClick: (type) ->
    @toggleDisplay(type)
    switch type
      when 'nonDisplay'
        @setState
          nonDisplay: true
          display: false
      when 'display'
        @setState
          nonDisplay: false
          display: true

  render: ->
    <div className='uk-button-group' style={marginBottom: '10px'}>
      <button onClick={() => @onClick('nonDisplay')} className={'uk-button uk-button-primary' + if @state.nonDisplay then ' uk-active' else ''}>非表示</button>
      <button onClick={() => @onClick('display')} className={'uk-button uk-button-danger' + if @state.display then ' uk-active' else ''}>表示</button>
    </div>
