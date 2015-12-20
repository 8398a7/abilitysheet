class @Footer extends React.Component
  render: ->
    now = new Date()
    year = now.getFullYear()
    <div className="relative">
      <div className="uk-panel panel-default">
        <span className="left-position">
          <a href="http://twitter.com/IIDX_12">
            <i className="fa fa-twitter" />
            Twitter
          </a>
        </span>
        <span>&copy; IIDX☆12参考表 by839 2014-{year}</span>
      </div>
    </div>
