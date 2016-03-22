class @Sheet extends React.Component
  constructor: (props) ->
    super
    @state =
      type:
        clear:
          name: 'ノマゲ参考表'
          remain: '未クリア'
          link: 'hard'
          button: 'uk-button-danger'
        hard:
          name: 'ハード参考表'
          link: 'clear'
          remain: '未難'
          button: 'uk-button-primary'
      remain: false
      twitterRemain: false
      viewport: EnvironmentStore.findBy 'viewport'

  onClickViewPort: =>
    params = getQueryParams location.search
    url = location.origin + location.pathname
    # parameterの付与/削除
    if @state.viewport is true then params.device = 'pc' else delete params.device
    history.replaceState '', '', mergeQueryParams url, params
    EnvironmentActionCreators.changeViewport !@state.viewport

  onChangeScore: =>
    @setState remain: ScoreStore.remain @props.type
    @setState twitterRemain: ScoreStore.remain @props.type if @state.remain is false

  onChangeViewPort: =>
    @setState viewport: EnvironmentStore.findBy 'viewport'

  componentWillMount: ->
    SheetActionCreators.get()
    EnvironmentActionCreators.judgeReverse()
    ScoreActionCreators.get iidxid: @props.user.iidxid
    ScoreStore.addChangeListener @onChangeScore
    EnvironmentStore.addChangeListener @onChangeViewPort

  componentWillUnmount: ->
    ScoreStore.removeChangeListener @onChangeScore
    EnvironmentStore.removeChangeListener @onChangeViewPort

  renderSwitchViewPort: ->
    <button className='uk-button' onClick={@onClickViewPort}>
      <i className='fa fa-refresh' />
      {if @state.viewport is true then 'PCサイト版' else 'モバイル版'}
    </button>

  render: ->
    <div className='react'>
      <div className='center'>
        <h2>
          <i className='fa fa-table' />
          {@state.type[@props.type].name}
          ({@state.type[@props.type].remain}{@state.remain})
        </h2>
        <h3>
          <a href={user_path(@props.user.iidxid)}>{"DJ.#{@props.user.djname}(#{@props.user.iidxid})"}</a>
        </h3>
        <TwitterSharedButton text="DJ.#{@props.user.djname} ☆12#{@state.type[@props.type].name}(#{@state.type[@props.type].remain}#{@state.twitterRemain})" />
        <ScreenShot />
        <a className="uk-button #{@state.type[@props.type].button}" href={sheet_path(iidxid: @props.user.iidxid, type: @state.type[@props.type].link)}>
          {@state.type[@props.type].link.toUpperCase()}
        </a>
        {@renderSwitchViewPort() if _ua.Mobile}
        <hr />
        <Checkbox versions={@props.versions} sheetType={@props.sheetType} lamp={@props.lamp} />
        <LampStatistics type={@props.type} />
        <h3 />
        <SheetList type={@props.type} user={@props.user} />
      </div>
    </div>

Sheet.propTypes =
  type: React.PropTypes.string.isRequired
  user: React.PropTypes.object.isRequired
