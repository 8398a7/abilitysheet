class @ScreenShot extends React.Component
  constructor: ->
    @state =
      capture: false
      download: false
      dataUrl: '#'
      text: 'スクリーンショット'

  onClick: =>
    return null if @state.capture
    @setState text: '保存中...'
    $('.google-adsense').hide()
    html2canvas document.body,
      onrendered: (canvas) =>
        @setState
          text: 'ダウンロード'
          capture: true
          download: 'ss.png'
          dataUrl: canvas.toDataURL 'image/png'
        $('.google-adsense').show()

  render: ->
    <a className='uk-button react' download={@state.download} id='ss' href={@state.dataUrl} onClick={@onClick}>
      <i className='fa fa-camera' />
      {@state.text}
    </a>
