class @UserProfileRight extends React.Component
  constructor: (props) ->
    super

  componentDidMount: ->
    $('#graph').append @props.graphDom

  render: ->
    <div className='uk-width-7-10'>
      <CalHeatmap user={@props.user} mobile={@props.mobile} />
      <div id='graph' />
    </div>

UserProfileRight.proptypes =
  user: React.PropTypes.object.isRequired
  graphDom: React.PropTypes.string.isRequired
  mobile: React.PropTypes.bool.isRequired
