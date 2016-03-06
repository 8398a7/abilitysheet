class @UserProfile extends React.Component
  constructor: (props) ->
    super
    @state =
      currentUser: UserStore.get()
      user: props.user

  onChangeCurrentUser: =>
    targetUser = UserStore.getTargetUser()
    if targetUser.id?
      @setState
        currentUser: UserStore.get()
        user: UserStore.getTargetUser()
    else
      @setState currentUser: UserStore.get()

  componentWillMount: ->
    UserStore.addChangeListener(@onChangeCurrentUser)
    UserActionCreators.getMe()

  componentWillUnmount: ->
    UserStore.removeChangeListener(@onChangeCurrentUser)

  render: ->
    <div className='uk-grid react'>
      <UserProfileLeft user={@state.user} currentUser={@state.currentUser} mobile={@props.mobile} />
      <UserProfileRight user={@state.user} graphDom={@props.graphDom} mobile={@props.mobile} />
    </div>

UserProfile.proptypes =
  user: React.PropTypes.object.isRequired
  graphDom: React.PropTypes.string.isRequired
  mobile: React.PropTypes.bool.isRequired
