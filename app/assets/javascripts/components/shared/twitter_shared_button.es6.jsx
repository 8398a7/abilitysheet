class TwitterSharedButton extends BaseComponent {
  // 一度コンポーネントが描画されたら再描画は行わない
  shouldComponentUpdate(nextProps, nextState) { return false }

  componentDidMount() {
    widgetoon_main()
  }

  render() {
    return (
      <a
        href='https://twitter.com/share'
        className='twitter-share-buttoon'
        data-url='https://iidx12.tk'
        data-text={this.props.text}
        data-count='horizontal'
        data-size='large'
        data-lang='ja'>ツイート</a>
    )
  }
}

TwitterSharedButton.propTypes = {
  text: React.PropTypes.string
}
