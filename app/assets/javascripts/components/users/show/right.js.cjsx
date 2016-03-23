class @UserProfileRight extends React.Component
  constructor: (props) ->
    super

  render: ->
    <div className='uk-width-7-10'>
      <CalHeatmap user={@props.user} viewport={@props.viewport} />
      <SplineGraph initialRender=false iidxid={@props.user.iidxid} />
    </div>

UserProfileRight.proptypes =
  user: React.PropTypes.object.isRequired
  viewport: React.PropTypes.bool.isRequired
