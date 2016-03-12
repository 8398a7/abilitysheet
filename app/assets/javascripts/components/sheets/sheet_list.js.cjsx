class @SheetList extends React.Component
  constructor: (props) ->
    super
    @state =
      sheets: SheetStore.get()
      scores: ScoreStore.get()
      displaySelect: ''
      renderAds: UserStore.renderAds()
      sortKey: 'asc'

  onChangeCurrentUser: =>
    @setState renderAds: UserStore.renderAds()

  onChangeSheet: =>
    @setState sheets: SheetStore.get()

  onChangeScore: =>
    @setState scores: ScoreStore.get()

  componentWillMount: ->
    SheetStore.addChangeListener @onChangeSheet
    ScoreStore.addChangeListener @onChangeScore
    UserStore.addChangeListener @onChangeCurrentUser

  componentWillUnmount: ->
    SheetStore.removeChangeListener @onChangeSheet
    ScoreStore.removeChangeListener @onChangeScore
    UserStore.removeChangeListener @onChangeCurrentUser

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
    for ability, objects of sheets
      dom.push <tr key={"#{@props.type}_#{ability}"}>
          <th colSpan=5 style={textAlign: 'center', backgroundColor: '#f5deb3'}>{objects.string}</th>
        </tr>
      delete objects.string
      keys = Object.sortedKeys objects, 'title', @state.sortKey
      for array in keys.chunk(5)
        count = 0
        dom.push <tr key={array[count]}>
            <LampTd iidxid={@props.user.iidxid} scores={@state.scores} display={@state.displaySelect} objects={objects} index={array[count++]} />
            <LampTd iidxid={@props.user.iidxid} scores={@state.scores} display={@state.displaySelect} objects={objects} index={array[count++]} />
            <LampTd iidxid={@props.user.iidxid} scores={@state.scores} display={@state.displaySelect} objects={objects} index={array[count++]} />
            <LampTd iidxid={@props.user.iidxid} scores={@state.scores} display={@state.displaySelect} objects={objects} index={array[count++]} />
            <LampTd iidxid={@props.user.iidxid} scores={@state.scores} display={@state.displaySelect} objects={objects} index={array[count++]} />
          </tr>
    dom

  onClickSelect: =>
    @setState displaySelect: if @state.displaySelect is '' then 'none' else ''

  render: ->
    <div>
      {
        <RectangleAdsense
          client='ca-pub-5751776715932993'
          slot='4549839260'
          slot2='3454772069'
          mobile=false
        /> if @state.renderAds
      }
      {<hr style={margin: '10px 0'} /> if @state.renderAds}
      <button onClick={@onClickSelect} className='uk-button uk-button-primary'>編集ボタン表示切替</button>
      <table className='uk-table uk-table-bordered'>
        <tbody>
          {@renderSheet()}
        </tbody>
      </table>
    </div>

SheetList.propTypes =
  type: React.PropTypes.string.isRequired
  user: React.PropTypes.object.isRequired
