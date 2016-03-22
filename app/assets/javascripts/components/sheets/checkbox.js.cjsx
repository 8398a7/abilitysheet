class @Checkbox extends React.Component
  constructor: (props) ->
    super

  render: ->
    <div className='checkbox'>
      <VersionCheckbox versions={@props.versions} />
      <LampCheckbox lamp={@props.lamp} />
    </div>

Checkbox.propTypes =
  versions: React.PropTypes.array.isRequired
  sheetType: React.PropTypes.number.isRequired
  lamp: React.PropTypes.array.isRequired
