classNames = require("classnames")
React = require("react/addons")
{RouteHandler, Link, State} = require("react-router")
{Path, SortTypes} = require("../constants/AppConstants")


module.exports = React.createClass
  mixins: [State]

  render: ->
    currentYear = new Date().getFullYear();

    routes = @getRoutes()
    lastPath = routes[routes.length-1]?.path

    wrapperClasses = classNames(
      "wrapper": true
      "is-wiki": lastPath == Path.WIKI
    )

    favoritesClasses = classNames(
      "active": lastPath == Path.FAVORITES
    )

    <div className={wrapperClasses}>

      <div className="header">
        <h1 className="brand"><Link to="/"><i className="icon-logo"></i> Clip Wiki</Link></h1>
        <ul className="gnav">
          <li className="gnav__item"><Link to={Path.SEARCH}><i className="fa fa-search"></i><span className="gnav__item__text">Search</span></Link></li>
          <li className="gnav__item"><Link to={Path.FAVORITES} className={favoritesClasses}><i className="fa fa-star-o"></i><span className="gnav__item__text">Favorites</span></Link></li>
          <li className="gnav__item"><Link to={Path.ABOUT}><i className="fa fa-tint"></i><span className="gnav__item__text">About</span></Link></li>
        </ul>
      </div>

      <RouteHandler {...@props} />

      <div className="footer">
        <ul className="footer__nav">
          <li><a href="https://github.com/tsuyoshiwada/react-wiki-clip" target="_blank"><i className="fa fa-github"></i> Source on GitHub</a></li>
          <li>Thank you for <a href="https://ja.wikipedia.org/wiki/" target="_blank">Wikipedia</a></li>
        </ul>
        <p className="copyright">&copy; {currentYear} Clip Wiki All Right Reserved.</p>
      </div>

    </div>
