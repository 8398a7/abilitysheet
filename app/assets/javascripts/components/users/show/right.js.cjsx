class @UserProfileRight extends React.Component
  constructor: (props) ->
    super

  componentDidMount: ->

  render: ->
    <div className='uk-width-7-10'>
      <CalHeatmap user={@props.user} mobile={@props.mobile} />
      <SplineGraph initialRender=false iidxid={@props.user.iidxid} />
    </div>

UserProfileRight.proptypes =
  user: React.PropTypes.object.isRequired
  mobile: React.PropTypes.bool.isRequired
