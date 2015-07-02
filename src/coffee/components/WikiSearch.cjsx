numeral = require("numeral")
React = require("react/addons")


LinkedStateMixin = React.addons.LinkedStateMixin


WikiSearch = React.createClass
  mixins: [LinkedStateMixin]

  propTypes: 
    keyword: React.PropTypes.string
    total: React.PropTypes.number
    page: React.PropTypes.number
    onKeywordChange: React.PropTypes.func

  getInitialState: ->
    keyword: @props.keyword || ""

  render: ->
    # 検索結果数の表示
    if @props.total
      total = numeral(@props.total).format("0,0")
      searchResult = 
        <div className="wiki-search__result">
          <h3 className="wiki-search__result__title">「{@props.keyword}」の検索結果 {total}件</h3>
        </div>

    <div className="wiki-search">
      <form onSubmit={@handleSubmit}>
        <div className="input-group">
          <input
            type="text"
            ref="wikiSearchInput"
            className="input-group__control control"
            placeholder="Seach keyword"
            valueLink={@linkState("keyword")}
            onClick={@handleClick} />
          <span className="input-group__btn">
            <button type="submit" className="btn btn--primary"><i className="fa fa-search"></i></button>
          </span>
        </div>
      </form>

      {searchResult}
    </div>

  handleSubmit: (e) ->
    e.preventDefault()
    @refs.wikiSearchInput.getDOMNode().blur()
    @props.onKeywordChange?(@state.keyword.trim())

  handleClick: (e) ->
    e.target.select()


module.exports = WikiSearch