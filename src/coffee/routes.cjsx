React = require("react")
Router = require("react-router")
{Route, DefaultRoute} = Router
{Path} = require("./constants/AppConstants")

App = require("./pages/App")
SearchPage = require("./pages/SearchPage")
AboutPage = require("./pages/AboutPage")
FavoritesPage = require("./pages/FavoritesPage")
WikiPage = require("./pages/WikiPage")


module.exports = 
  <Route handler={App}>
    <Route path={Path.SEARCH} handler={SearchPage} />
    <Route path={Path.FAVORITES} handler={FavoritesPage} />
    <Route path={Path.ABOUT} handler={AboutPage} />
    <Route path={Path.WIKI}>
      <DefaultRoute handler={WikiPage} />
    </Route>
  </Route>