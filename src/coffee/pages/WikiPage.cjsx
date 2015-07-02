classNames = require("classnames")
React = require("react")
{State, Navigation} = require("react-router")
Fluxxor = require("fluxxor")
{APIEndpoints, Path} = require("../constants/AppConstants")
Loading = require("../components/Loading")


module.exports = React.createClass
  mixins: [
    Fluxxor.FluxMixin(React)
    Fluxxor.StoreWatchMixin("wiki")
    State
    Navigation
  ]

  getStateFromFlux: ->
    @getFlux().store("wiki").getState()

  componentDidMount: ->
    @getFlux().actions.wiki.find(@getParams().title)
    document.addEventListener("click", @handleDocumentClick, false)

  componentWillUnmount: ->
    document.removeEventListener("click", @handleDocumentClick, false)

  render: ->
    title = @state.wiki?.title
    content = @state.wiki?.content
    permalink = APIEndpoints.WIKI + title
    btnFavClasses = classNames(
      "btn btn--transparent btn--sm wiki__btn--fav": true
      "is-fav": @state.wiki?.favorite
    )

    <div className="wiki-single" id="wiki-single-scrollable">
      <div className="wiki-single__loading">
        <Loading show={@state.loading} />
      </div>
      <div className="wiki-single__heading" id="wiki-single-heading">
        <div className="wiki-single__control wiki-single__control--left">
          <button className="btn btn--transparent btn--sm" onClick={@handleBackClick}><i className="fa fa-reply"></i></button>
        </div>
        <p className="wiki-single__title">{title}</p>
        <div className="wiki-single__control wiki-single__control--right">
          <button className={btnFavClasses} onClick={@handleFavClick}><i className="fa fa-star"></i></button>
          <a className="btn btn--transparent btn--sm" href={permalink} target="_blank"><i className="fa fa-external-link"></i></a>
        </div>
      </div>
      <div className="wiki-single__body">
        <div className="container" dangerouslySetInnerHTML={{__html: content}}></div>
      </div>
    </div>

  handleDocumentClick: (e) =>
    anchor = null

    if e.target.className == "toctext"
      anchor = e.target.parentNode
    else if e.target.tagName == "A" && /^#.+$/.test(e.target.getAttribute("href"))
      anchor = e.target

    if anchor?
      e.preventDefault()
      doc = document
      heading = doc.getElementById("wiki-single-heading")
      target = doc.getElementById(anchor.getAttribute("href").slice(1))
      rect = target.getBoundingClientRect()
      window.scrollTo(0, rect.top - heading.clientHeight)

  handleBackClick: (e) ->
    # Historyのスタックがない状態の時は`goBack`でfalseが返るので検索画面にリダイレクトさせる
    if !@goBack()
      @transitionTo(Path.SEARCH)

  handleFavClick: (e) ->
    wiki = @state.wiki
    @getFlux().actions.wiki.favoriteToggle(@state.wiki)
    wiki.favorite = !wiki.favorite
    @setState(wiki: wiki)
