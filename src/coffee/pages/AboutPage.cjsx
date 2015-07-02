React = require("react")
{Link} = require("react-router")
{Path} = require("../constants/AppConstants")
Jumbotron = require("../components/Jumbotron")


module.exports = React.createClass
  render: ->
    <div className="contents">
      <div className="page-heading">
        <div className="container">
          <h2 className="page-heading__title">このサイトについて</h2>
        </div>
      </div>

      <div className="container">
        <Jumbotron title="Clip Wiki" icon="icon-logo">
          <p>
            <a href="https://ja.wikipedia.org/" target="_blank">Wikipedia</a>が提供する<a href="https://www.mediawiki.org/wiki/API:Main_page">MediaWikiAPI</a>を使ったOSS(オープンソース・ソフトウェア)です。<br />
            React.js、Fluxのサンプルとして制作しました。
          </p>
          <p>
            気になったキーワードがあれば、ログインせずにその場でお気に入りとしてクリップしておくことが出来ます。<br />
            ちょっとした調べ物などにご活用頂ければと思います。
          </p>
          <p><Link to={Path.SEARCH}>検索のページはこちら</Link></p>
        </Jumbotron>
      </div>
    </div>
