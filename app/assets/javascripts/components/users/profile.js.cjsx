class @UserProfile extends React.Component
  constructor: (props) ->
    super

  render: ->
    <div>
      <image src={@props.user.image.url} />
      {@props.user.djname}
      {@props.user.grade}
    </div>

UserProfile.proptypes =
  user: React.PropTypes.object.isRequired
