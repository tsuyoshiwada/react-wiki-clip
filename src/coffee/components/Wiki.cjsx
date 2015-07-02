moment = require("moment")
classNames = require("classnames")
React = require("react")
{Link} = require("react-router")
Fluxxor = require("fluxxor")
{Path, APIEndpoints} = require("../constants/AppConstants")
ShareLink = require("./ShareLink")



module.exports = React.createClass
  mixins: [Fluxxor.FluxMixin(React)]

  propTypes: 
    wiki: React.PropTypes.object.isRequired

  render: ->
    wiki = @props.wiki
    
    encodedTitle = encodeURIComponent(wiki.title)
    permalink = APIEndpoints.WIKI + encodedTitle

    {protocol, host, pathname} = window.location
    shareUrl = "#{protocol}#{host}#{pathname}#" + Path.WIKI.replace(":title", encodedTitle)
    shareText = "#{wiki.title} | Clip Wiki - Wikipediaビューワーアプリ"

    btnFavClasses = classNames(
      "wiki__btn wiki__btn--fav": true
      "is-fav": wiki.favorite
    )

    <div className="wiki">
      <div className="wiki__inner">
        <div className="wiki__btn-group">
          <ShareLink type="twitter" url={shareUrl} text={shareText} className="wiki__btn wiki__btn--twitter">
            <i className="fa fa-twitter"></i>
          </ShareLink>
          <ShareLink type="facebook" url={shareUrl} className="wiki__btn wiki__btn--facebook">
            <i className="fa fa-facebook"></i>
          </ShareLink>
          <button
            className={btnFavClasses}
            onClick={@handleFavoriteClick}>
            <i className="fa fa-star"></i>
          </button>
          <a
            className="wiki__btn wiki__btn--link"
            href={permalink}
            target="_blank">
            <i className="fa fa-external-link"></i>
          </a>
        </div>
        {@renderMeta()}
        <h3 className="wiki__title"><Link to={Path.WIKI} params={title: encodedTitle}>{wiki.title}</Link></h3>
        <div className="wiki__excerpt" dangerouslySetInnerHTML={{__html: wiki.snippet}} />
      </div>
    </div>

  renderMeta: ->
    wiki = @props.wiki
    dateFormat = "YYYY/MM/DD HH:mm:SS"

    if wiki.timestamp && wiki.size && wiki.wordcount
      date = moment(wiki.timestamp).format(dateFormat)
      <div className="wiki__meta">
        <span className="wiki__date">最終更新日時: {date}</span>
        <span className="wiki__size">{wiki.size}文字</span>
        <span className="wiki__words">{wiki.wordcount}単語</span>
      </div>

    else if wiki.created
      date = moment(wiki.created, "x").format(dateFormat)
      <div className="wiki__meta">
        <span className="wiki__date">追加日時: {date}</span>
      </div>

  handleFavoriteClick: (e) ->
    e.preventDefault()
    @getFlux().actions.wiki.favoriteToggle(@props.wiki)

