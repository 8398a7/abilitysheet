@Irt = React.createClass
  displayName: 'Irt'

  propTypes:
    paths: React.PropTypes.object

  componentDidMount: ->

  render: ->
    <li>
      <a href={@props.paths.recommend}><i className="fa fa-level-up"></i>&nbsp;地力値表</a>
    </li>
