class @SheetList extends React.Component
  constructor: (props) ->
    super
    @state =
      sheets: SheetStore.get()
      scores: ScoreStore.get()
      displaySelect: ''
      renderAds: UserStore.renderAds()
      viewport: EnvironmentStore.findBy 'viewport'
      reverse: EnvironmentStore.findBy 'reverseSheet'

  onChangeViewPortAndReverse: =>
    @setState
      viewport: EnvironmentStore.findBy 'viewport'
      reverse: EnvironmentStore.findBy 'reverseSheet'

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
    EnvironmentStore.addChangeListener @onChangeViewPortAndReverse

  componentWillUnmount: ->
    SheetStore.removeChangeListener @onChangeSheet
    ScoreStore.removeChangeListener @onChangeScore
    UserStore.removeChangeListener @onChangeCurrentUser
    EnvironmentStore.removeChangeListener @onChangeViewPort

  classificationSheet: ->
    sheets = {}
    for id, sheet of @state.sheets
      sheets[sheet[@props.type]] ||= {}
      sheets[sheet[@props.type]][id] = sheet
      sheets[sheet[@props.type]].string = sheet["#{@props.type}_string"]
    sheets

  setAbilities: (sheets) ->
    abilities = Object.keys(sheets).map (ability) => parseInt ability
    abilities = abilities.reverse() if @state.reverse
    abilities

  renderSheet: ->
    sheets = @classificationSheet()
    abilities = @setAbilities sheets

    dom = []
    for ability in abilities
      objects = sheets[ability]
      dom.push <tr key={"#{@props.type}_#{ability}"}>
          <th colSpan=5 style={textAlign: 'center', backgroundColor: '#f5deb3'}>{objects.string}</th>
        </tr>
      delete objects.string
      keys = Object.sortedKeys objects, 'title', 'asc'
      for array in keys.chunk(5)
        count = 0
        dom.push <tr key={array[count]}>
            <LampTd width=150 height=50 iidxid={@props.user.iidxid} scores={@state.scores} display={@state.displaySelect} objects={objects} index={array[count++]} />
            <LampTd width=150 height=50 iidxid={@props.user.iidxid} scores={@state.scores} display={@state.displaySelect} objects={objects} index={array[count++]} />
            <LampTd width=150 height=50 iidxid={@props.user.iidxid} scores={@state.scores} display={@state.displaySelect} objects={objects} index={array[count++]} />
            <LampTd width=150 height=50 iidxid={@props.user.iidxid} scores={@state.scores} display={@state.displaySelect} objects={objects} index={array[count++]} />
            <LampTd width=150 height=50 iidxid={@props.user.iidxid} scores={@state.scores} display={@state.displaySelect} objects={objects} index={array[count++]} />
          </tr>
    dom

  onClickSelect: =>
    @setState displaySelect: if @state.displaySelect is '' then 'none' else ''

  renderMobileSheet: ->
    sheets = @classificationSheet()
    abilities = @setAbilities sheets

    dom = []
    for ability in abilities
      objects = sheets[ability]
      dom.push <tr key={"#{@props.type}_#{ability}"}>
          <th style={textAlign: 'center', backgroundColor: '#f5deb3'}>{objects.string}</th>
        </tr>
      delete objects.string
      for key in Object.sortedKeys objects, 'title', 'asc'
        dom.push <tr key={key}>
            <LampTd iidxid={@props.user.iidxid} scores={@state.scores} display={@state.displaySelect} objects={objects} index={key} />
          </tr>
    dom

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
          {
            if _ua.Mobile and @state.viewport
              @renderMobileSheet()
            else
              @renderSheet()
          }
        </tbody>
      </table>
    </div>

SheetList.propTypes =
  type: React.PropTypes.string.isRequired
  user: React.PropTypes.object.isRequired
