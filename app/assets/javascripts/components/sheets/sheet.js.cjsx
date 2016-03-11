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
      renderAds: UserStore.renderAds()

  onChangeCurrentUser: =>
    @setState renderAds: UserStore.renderAds()

  componentWillMount: ->
    SheetActionCreators.get()
    UserStore.addChangeListener @onChangeCurrentUser

  componentWillUnmount: ->
    UserStore.removeChangeListener @onChangeCurrentUser

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
        <a className="uk-button #{@state.type[@props.type].button}" href={sheet_path(iidxid: @props.user.iidxid, type: @state.type[@props.type].link)}>
          {@state.type[@props.type].link.toUpperCase()}
        </a>
        <ScreenShot />
        <hr />
        {
          <RectangleAdsense
            client='ca-pub-5751776715932993'
            slot='4549839260'
            slot2='3454772069'
            mobile={@props.mobile}
          /> if @state.renderAds
        }
        {<hr style={margin: '10px 0'} /> if @state.renderAds}
        <Checkbox versions={@props.versions} reverseSheet={@props.reverseSheet} sheetType={@props.sheetType} lamp={@props.lamp} />
        <LampStatistics mobile={@props.mobile} />
        <h3 />
        <SheetList type={@props.type} />
      </div>
    </div>

Sheet.propTypes =
  type: React.PropTypes.string.isRequired
  user: React.PropTypes.object.isRequired
  mobile: React.PropTypes.bool.isRequired
