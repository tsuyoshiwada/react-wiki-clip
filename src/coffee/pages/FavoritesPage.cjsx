_ = require("underscore")
React = require("react")
{Link, State, Navigation} = require("react-router")
Fluxxor = require("fluxxor")
classNames = require("classnames")
{Path, SortTypes, ViewTypes} = require("../constants/AppConstants")
Jumbotron = require("../components/Jumbotron")
Wiki = require("../components/Wiki")

module.exports = React.createClass
  mixins: [
    Fluxxor.FluxMixin(React)
    Fluxxor.StoreWatchMixin("wiki")
    State,
    Navigation
  ]

  getInitialState: ->
    query = @getQuery()
    sort: query.sort || SortTypes.ASC
    view: query.view || ViewTypes.CARD

  getStateFromFlux: ->
    @getFlux().store("wiki").getState()

  componentDidMount: ->
    @getFlux().actions.wiki.fetchFavorites()

  render: ->
    sortIconClassess = classNames(
      "fa": true
      "fa-sort-numeric-asc" : @state.sort == SortTypes.DESC
      "fa-sort-numeric-desc" : @state.sort == SortTypes.ASC
    )

    viewIconClassess = classNames(
      "fa": true
      "fa-bars": @state.view == ViewTypes.CARD
      "fa-th-large": @state.view == ViewTypes.LIST
    )

    <div className="contents">
      <div className="page-heading">
        <div className="container">
          <h2 className="page-heading__title">お気に入り</h2>
        </div>
      </div>

      <div className="container">
        <div className="favorite-controls">
          <p className="favorite-controls__total">{@getFavoriteLength()} 件のお気に入り</p>
          <div className="favorite-controls__btn-group btn-group">
            <button type="button" className="btn btn--transparent btn--sm" onClick={@handleViewClick}><i className={viewIconClassess}></i></button>
            <button type="button" className="btn btn--transparent btn--sm" onClick={@handleSortClick}><i className={sortIconClassess}></i></button>
            <button type="button" className="btn btn--transparent btn--sm" onClick={@handleDestroyClick}><i className="fa fa-trash-o"></i></button>
          </div>
        </div>
        {@renderWikis()}
      </div>
    </div>

  renderWikis: ->
    if @getFavoriteLength() == 0
      return <Jumbotron title="まだお気に入りがありません">
        <p>気に入った単語を見つけてお気に入りに追加してみましょう。</p>
        <p><Link to={Path.SEARCH}>キーワードから探す</Link></p>
      </Jumbotron>

    wikis = []
    favorites = @state.favorites

    if @state.sort
      sort = if @state.sort == SortTypes.ASC then 1 else -1
      favorites = _.sortBy(favorites, (wiki) ->
        parseInt(wiki.created) * sort
      )

    for title, wiki of favorites
      wikis.push(<Wiki wiki={wiki} key={title} />)

    wikiListClassess = classNames(
      "wiki-list": true
      "wiki-list--card": @state.view == ViewTypes.CARD
    )

    <div className={wikiListClassess}>
      {wikis}
    </div>

  handleDestroyClick: (e) ->
    e.preventDefault()
    @getFlux().actions.wiki.favoriteDestroyAll()

  handleViewClick: (e) ->
    view = if @state.view == ViewTypes.LIST then ViewTypes.CARD else ViewTypes.LIST
    @replaceWith(Path.FAVORITES, {}, 
      view: view
      sort: @state.sort
    )
    @setState(view: view)

  handleSortClick: (e) ->
    sort = if @state.sort == SortTypes.ASC then SortTypes.DESC else SortTypes.ASC
    @replaceWith(Path.FAVORITES, {}, 
      view: @state.view
      sort: sort
    )
    @setState(sort: sort)

  getFavoriteLength: ->
    Object.keys(@state.favorites).length
