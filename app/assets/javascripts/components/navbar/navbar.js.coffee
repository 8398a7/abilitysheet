@Navbar = React.createClass
  displayName: 'Navbar'

  propTypes:
    paths: React.PropTypes.object
    current_user: React.PropTypes.object
    recent: React.PropTypes.string

  componentDidMount: ->

  render: ->
    <div className="uk-container uk-container-center">
      <a href={@props.paths.root} className="uk-navbar-brand">
        <span className="brand bold">☆12参考表</span>
      </a>
      <ul className="uk-navbar-nav uk-hidden-small">
        <li>
          <a href={@props.paths.users}>
            <i className="fa fa-refresh"></i>
            最近更新したユーザ
          </a>
        </li>
        <MyPage current_user={@props.current_user} paths={@props.paths} recent={@props.recent} />
        <Rival paths={@props.paths} />
        <Irt paths={@props.paths} />
        <Conntact paths={@props.paths} />
        <Admin paths={@props.paths} />
      </ul>
      <div className="uk-navbar-flip uk-hidden-small">
        <ul className="uk-navbar-nav">
          <User paths={@props.paths} />
        </ul>
      </div>
    </div>
#        .uk-navbar-flip.uk-visible-small
#          a.uk-navbar-toggle href="#navbar-offcanvas" data-uk-offcanvas=""

