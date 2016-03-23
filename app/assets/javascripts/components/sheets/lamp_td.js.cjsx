class @LampTd extends React.Component
  constructor: (props) ->
    super
    @state =
      currentUser: UserStore.get()

  onChangeCurrentUser: =>
    @setState currentUser: UserStore.get()

  componentWillMount: ->
    UserStore.addChangeListener @onChangeCurrentUser

  componentWillUnmount: ->
    UserStore.removeChangeListener @onChangeCurrentUser

  onClick: (id) =>
    SheetModalActionCreators.get iidxid: @props.iidxid, sheetId: id

  render: ->
    return <td style={display: 'none'} /> unless @props.objects[@props.index]?
    <td
      width={@props.width}
      height={@props.height}
      style={
        display: @props.scores[@props.index]?.display
        backgroundColor: @props.scores[@props.index]?.color
      }
    >
      <a style={color: '#555555'} onClick={() => @onClick @props.objects[@props.index].id} href='#sheet-modal' data-uk-modal>{@props.objects[@props.index].title}</a>
      {<LampSelect display={@props.display} score={@props.scores[@props.index]} iidxid={@props.iidxid} /> if @state.currentUser.iidxid is @props.iidxid}
    </td>

LampTd.propTypes =
  objects: React.PropTypes.object.isRequired
  index: React.PropTypes.string
  scores: React.PropTypes.object.isRequired
  display: React.PropTypes.string.isRequired
  iidxid: React.PropTypes.string.isRequired
  width: React.PropTypes.number
  height: React.PropTypes.number
