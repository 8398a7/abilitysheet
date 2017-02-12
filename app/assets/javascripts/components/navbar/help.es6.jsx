class Help extends BaseComponent {
  render() {
    return (
      <li className='uk-parent' data-uk-dropdown>
        <a><i className='fa fa-question' />ヘルプ</a>
        <div className='uk-dropdown uk-dropdown-navbar'>
          <ul className='uk-nav uk-nav-navbar'>
            <li><a href={official_help_path()}><i className='fa fa-jsfiddle' />公式とのデータ同期</a></li>
          </ul>
        </div>
      </li>
    )
  }
}
