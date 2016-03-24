class @UserProfileLeft extends React.Component
  constructor: (props) ->
    super
    @state =
      grades: StaticStore.get().grade?
      pref: StaticStore.get().pref
      date: new Date props.user.createdAt
      addRival: 'ライバルに追加'
      removeRival: 'ライバルから削除'
      normal: 'ノマゲ参考表'
      hard: 'ハード参考表'
      compareNormal: 'ノマゲ比較'
      compareHard: 'ハード比較'

  componentWillMount: ->
    StaticStore.addChangeListener @onChangeGrade
    StaticActionCreators.get()
    @setGrade()
    if _ua.Mobile and @props.viewport
      @setState
        addRival: '追加'
        removeRival: '削除'
        normal: 'ノマゲ'
        hard: 'ハード'
        compareNormal: '比較'
        compareHard: '比較'

  componentWillUnmount: ->
    StaticStore.removeChangeListener @onChangeGrade

  onChangeGrade: =>
    @setGrade()

  setGrade: ->
    grades = StaticStore.get().grade
    return unless grades?
    for gradeString, gradeColor of grades[@props.user.grade]
      @setState
        pref: StaticStore.get().pref
        grades: grades
        gradeString: gradeString
        gradeColor: gradeColor

  compareDom: ->
    return null unless @props.currentUser.id?
    return null if @props.currentUser.iidxid is @props.user.iidxid
    <div>
      <a className='uk-button uk-button-primary' href={clear_rival_path(@props.user.iidxid)}>{@state.compareNormal}</a>
      <a className='uk-button uk-button-danger' href={hard_rival_path(@props.user.iidxid)}>{@state.compareHard}</a>
    </div>

  changeRival: =>
    UserActionCreators.changeRival @props.user.iidxid

  renderRival: ->
    return null unless @props.currentUser.id?
    return null if @props.currentUser.iidxid is @props.user.iidxid
    if @props.currentUser.follows.indexOf(@props.user.iidxid) is -1
      <button className='uk-button' onClick={@changeRival}><i className='fa fa-user-plus' />{@state.addRival}</button>
    else
      <button className='uk-button' onClick={@changeRival}><i className='fa fa-user-times' />{@state.removeRival}</button>

  render: ->
    <div className='uk-width-3-10'>
      <image className='icon' src={@props.user.imageUrl} />
      <div style={marginTop: '20px'}><h2><b>{@props.user.djname}</b></h2></div>
      <div><h3>{@props.user.iidxid}&nbsp;{@renderRival()}</h3></div>
      <div style={paddingBottom: '3px'}>
        <TwitterSharedButton
          text="DJ.#{@props.user.djname} ☆12参考表プロフィール"
        />
      </div>
      <div style={paddingBottom: '3px'}>
        <a className='uk-button uk-button-primary' href={sheet_path(@props.user.iidxid, type: 'clear')}>{@state.normal}</a>
        <a className='uk-button uk-button-danger' href={sheet_path(@props.user.iidxid, type: 'hard')}>{@state.hard}</a>
      </div>
      {@compareDom()}
      <hr />
      <div><i className='fa fa-street-view' />{@state.gradeString}</div>
      {<div><i className='fa fa-map-marker' />{@state.pref[@props.user.pref]}</div> if @state.pref}
      <div><i className='fa fa-clock-o' />Joined on {@state.date.getFullYear()}/{@state.date.getMonth() + 1}/{@state.date.getDate()}</div>
      <hr />
      <RivalNumber user={@props.user} />
    </div>

UserProfileLeft.proptypes =
  user: React.PropTypes.object.isRequired
  currentUser: React.PropTypes.object
  viewport: React.PropTypes.bool.isRequired
