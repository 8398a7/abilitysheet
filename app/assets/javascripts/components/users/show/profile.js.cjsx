class @UserProfile extends React.Component
  constructor: (props) ->
    super
    @state =
      currentUser: UserStore.get()
      user: props.user
      viewport: EnvironmentStore.findBy 'viewport'

  onChangeViewPort: =>
    @setState viewport: EnvironmentStore.findBy 'viewport'

  onChangeCurrentUser: =>
    targetUser = UserStore.getTargetUser()
    if targetUser.id?
      @setState
        currentUser: UserStore.get()
        user: UserStore.getTargetUser()
    else
      @setState currentUser: UserStore.get()

  componentWillMount: ->
    EnvironmentStore.addChangeListener @onChangeViewPort
    UserStore.addChangeListener @onChangeCurrentUser
    UserActionCreators.getMe()

  componentWillUnmount: ->
    EnvironmentStore.removeChangeListener @onChangeViewPort
    UserStore.removeChangeListener @onChangeCurrentUser

  render: ->
    <div className='uk-grid react'>
      <UserProfileLeft user={@state.user} currentUser={@state.currentUser} viewport={@state.viewport} />
      <UserProfileRight user={@state.user} graphDom={@props.graphDom} viewport={@state.viewport} />
    </div>

UserProfile.proptypes =
  user: React.PropTypes.object.isRequired
  graphDom: React.PropTypes.string.isRequired
