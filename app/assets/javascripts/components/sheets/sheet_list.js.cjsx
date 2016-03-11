class @SheetList extends React.Component
  constructor: (props) ->
    super
    @state =
      sheets: {}

  onChangeSheet: =>
    @setState sheets: SheetStore.get()

  componentWillMount: ->
    SheetStore.addChangeListener @onChangeSheet
    SheetActionCreators.get()

  componentWillUnmount: ->
    SheetStore.removeChangeListener @onChangeSheet

  classificationSheet: ->
    sheets = {}
    for id, sheet of @state.sheets
      sheets[sheet[@props.type]] ||= {}
      sheets[sheet[@props.type]][id] = sheet
      sheets[sheet[@props.type]].string = sheet["#{@props.type}_string"]
    sheets

  renderSheet: ->
    sheets = @classificationSheet()

    dom = []
    for ability, object of sheets
      dom.push <tr key={"#{@props.type}_#{ability}"}>
          <th colSpan=5 style={textAlign: 'center', backgroundColor: '#f5deb3'}>{object.string}</th>
        </tr>
      delete object.string
      keys = Object.sortedKeys object, 'title', 'asc'
      for array in keys.chunk(5)
        console.log array if ability is '3'
        dom.push <tr>
            <td>{object[array[0]]?.title}</td>
            <td>{object[array[1]]?.title}</td>
            <td>{object[array[2]]?.title}</td>
            <td>{object[array[3]]?.title}</td>
            <td>{object[array[4]]?.title}</td>
          </tr>
    dom

  render: ->
    <div>
      <table className='uk-table uk-table-bordered'>
        <tbody>
        {@renderSheet()}
        </tbody>
      </table>
    </div>

SheetList.propTypes =
  type: React.PropTypes.string.isRequired
