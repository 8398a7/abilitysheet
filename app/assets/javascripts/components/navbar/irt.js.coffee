@Irt = React.createClass
  displayName: 'Irt'

  propTypes:
    paths: React.PropTypes.object

  componentDidMount: ->

  render: ->
    <li className="uk-parent" data-uk-dropdown="">
      <a><i className="fa fa-level-up"></i>地力値関係</a>
      <div className="uk-dropdown uk-dropdown-navbar">
        <ul className="uk-nav uk-nav-navbar">
          <li><a href={@props.paths.recommend}>☆12+AAA</a></li>
          <li><a href={@props.paths.integration_recommend}>統合表</a></li>
        </ul>
      </div>
    </li>
