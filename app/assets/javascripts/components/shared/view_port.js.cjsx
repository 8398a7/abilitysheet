class @ViewPort extends React.Component
  constructor: (props) ->
    super
    @state =
      viewport: EnvironmentStore.findBy 'viewport'

  onChangeViewPort: =>
    @setState viewport: EnvironmentStore.findBy 'viewport'

  componentWillMount: ->
    EnvironmentStore.addChangeListener @onChangeViewPort

  componentWillUnmount: ->
    EnvironmentStore.removeChangeListener @onChangeViewPort

  render: ->
    return <meta name='viewport' /> unless @state.viewport
    <meta name='viewport' content='width=device-width, initial-scale=1' />
