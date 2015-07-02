React = require("react")
Fluxxor = require("fluxxor")
{ErrorTypes} = require("../constants/AppConstants")
Loading = require("../components/Loading")
Jumbotron = require("../components/Jumbotron")
SearchStart = require("../components/SearchStart")
WikiSearch = require("../components/WikiSearch")
Wiki = require("../components/Wiki")


SCROLL_MARGIN_BOTTOM = 200


module.exports = React.createClass
  mixins: [
    Fluxxor.FluxMixin(React)
    Fluxxor.StoreWatchMixin("wiki")
  ]

  getStateFromFlux: ->
    @getFlux().store("wiki").getState()

  componentDidMount: ->
    @getFlux().actions.wiki.fetchFavorites()

    # 無限スクロール
    if navigator.userAgent.indexOf("WebKit") < 0
      @_rootScrollable = document.documentElement
    else
      @_rootScrollable = document.body

    window.addEventListener("scroll", @handleScroll, false)

  componentWillUnmount: ->
    window.removeEventListener("scroll", @handleScroll, false)

  render: ->
    <div className="contents">
      <div className="page-heading">
        <div className="container">
          <h2 className="page-heading__title">キーワード検索</h2>
          <WikiSearch
            keyword={@state.keyword}
            total={@state.total}
            onKeywordChange={@handleKeywordChange} />
        </div>
      </div>

      <div className="container">
        {@renderWikis()}
        <Loading show={@state.loading} />
      </div>
    </div>

  renderWikis: ->
    if @state.error == ErrorTypes.WIKI.NOT_FOUND
      return <Jumbotron title="お探しのキーワードが見つかりませんでした" icon="fa fa-exclamation-triangle">
        <p>キーワードを変えて再度検索してみて下さい。</p>
      </Jumbotron>

    wikis = @state.wikis.map((wiki, i) =>
      <Wiki wiki={wiki} key={i} />
    )

    <div className="wiki-list">
      {wikis}
    </div>

  handleScroll: (e) ->
    {scrollTop, scrollHeight} = @_rootScrollable
    clientHeight = document.body.clientHeight

    if scrollHeight - clientHeight - scrollTop <= SCROLL_MARGIN_BOTTOM
      @handlePageBottom()

  handlePageBottom: ->
    if !@state.last && !@state.loading && @state.keyword != ""
      @getFlux().actions.wiki.paginate(@state.keyword)

  handleKeywordChange: (value) ->
    @setState(keyword: value)
    @getFlux().actions.wiki.fetch(value)
