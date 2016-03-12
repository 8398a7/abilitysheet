class @Sheet extends React.Component
  constructor: (props) ->
    super
    @state =
      type:
        clear:
          name: 'ノマゲ参考表'
          link: 'hard'
          button: 'uk-button-danger'
        hard:
          name: 'ハード参考表'
          link: 'clear'
          button: 'uk-button-primary'

  componentWillMount: ->
    SheetActionCreators.get()
    ScoreActionCreators.get iidxid: @props.user.iidxid

  render: ->
    <div className='react'>
      <div className='center'>
        <h2>
          <i className='fa fa-table' />{@state.type[@props.type].name}
          <span id='remain' />
        </h2>
        <h3>
          <a href={user_path(@props.user.iidxid)}>{"DJ.#{@props.user.djname}(#{@props.user.iidxid})"}</a>
        </h3>
        <TwitterSharedButton text="#{@props.user.djname} remain" />
        <ScreenShot />
        <a className="uk-button #{@state.type[@props.type].button}" href={sheet_path(iidxid: @props.user.iidxid, type: @state.type[@props.type].link)}>
          {@state.type[@props.type].link.toUpperCase()}
        </a>
        <hr />
        <Checkbox versions={@props.versions} reverseSheet={@props.reverseSheet} sheetType={@props.sheetType} lamp={@props.lamp} />
        <LampStatistics type={@props.type} />
        <h3 />
        <SheetList type={@props.type} user={@props.user} />
      </div>
    </div>

Sheet.propTypes =
  type: React.PropTypes.string.isRequired
  user: React.PropTypes.object.isRequired
