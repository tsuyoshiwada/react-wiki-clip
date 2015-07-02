assign = require("object-assign")
store = require("store")
Promise = require("es6-promise").Promise
request = require("superagent")
require("superagent-jsonp")(request)
{APIEndpoints, APISettings, ErrorTypes} = require("../constants/AppConstants")


Keys = 
  FAVORITE: "favorites"
  SORT: "sort"

_currentPageMap = {}


_filterContent = (content) ->
  content = content.replace(/href=["']\/wiki\/(.*?)["']/g, "href='#{APIEndpoints.WIKI}$1' target='_blank'")
  content


_normalizeFetchResult = (data, options) ->
  keyword: options.srsearch
  wikis: data.query.search
  total: data.query.searchinfo.totalhits


_normalizeFindResult = (data) ->
  keys = Object.keys(data.query.pages)
  wiki = data.query.pages[keys[0]]
  pageid: wiki.pageid
  title: wiki.title
  content: _filterContent(wiki.revisions[0]["*"])


_fetch = (options) ->
  new Promise((resolve, reject) ->
    _options = assign({}, 
      format: "json"
      action: "query"
      list: "search"
      srsearch: ""
    , options)

    request
      .get(APIEndpoints.API)
      .query(_options)
      .jsonp()
      .end((res) ->
        if res.query.searchinfo.totalhits > 0
          resolve(_normalizeFetchResult(res, _options))
        else
          reject(error: ErrorTypes.WIKI.NOT_FOUND)
      )
  )


_fetchFavorites = ->
  new Promise((resolve, reject) ->
    favorites = store.get(Keys.FAVORITE)
    if favorites
      resolve(favorites)
    else
      reject(error: ErrorTypes.FAVORITE_NOT_FOUND)
  )


module.exports = 

  fetch: (keyword) ->
    new Promise((resolve, reject) ->
      keyword = keyword.trim()
      return reject(error: ErrorTypes.WIKI.KEYWORD_NOT_EXISTS) unless keyword

      _currentPageMap[keyword] = page = 0

      _fetch(
        srsearch: keyword
        srlimit: APISettings.LIMIT
      )
      .then((data) ->
        data.page = page
        resolve(data)
      )
      .catch(reject)
    )

  paginate: (keyword) ->
    new Promise((resolve, reject) ->
      keyword = keyword.trim()
      return reject(error: ErrorTypes.WIKI.KEYWORD_NOT_EXISTS) unless keyword

      page = ++_currentPageMap[keyword]

      _fetch(
        srsearch: keyword
        srlimit: APISettings.LIMIT
        sroffset: APISettings.LIMIT * page
      )
      .then((data) ->
        data.page = page
        resolve(data)
      )
      .catch(reject)
    )

  find: (keyword) ->
    new Promise((resolve, reject) ->
      keyword = keyword.trim()
      return reject(error: ErrorTypes.WIKI.KEYWORD_NOT_EXISTS) unless keyword

      request
        .get(APIEndpoints.API)
        .query(
          format: "json"
          action: "query"
          prop: "revisions"
          rvprop: "content"
          rvparse: ""
          titles: keyword
        )
        .jsonp()
        .end((res) ->
          if !res.query.pages
            reject(error: ErrorTypes.WIKI.NOT_FOUND)
            return

          wiki = _normalizeFindResult(res)

          _fetchFavorites()
          .then((favorites) =>
            wiki.favorite = !!favorites[wiki.title]
            resolve(wiki: wiki)
          )
          .catch(
            wiki.favorite = false
            resolve(wiki: wiki)
          )
        )
    )

  fetchFavorites: ->
    new Promise((resolve, reject) ->
      _fetchFavorites()
      .then((favorites) ->
        resolve(favorites: favorites)
      )
      .catch(reject)
    )

  favoriteAdd: (wiki) ->
    new Promise((resolve, reject) ->
      _fetchFavorites()
      .then((favorites) ->
        favorites[wiki.title] = wiki
        store.set(Keys.FAVORITE, favorites)
        resolve(favorites)
      )
      .catch(
        favorites = {}
        favorites[wiki.title] = wiki
        store.set(Keys.FAVORITE, favorites)
        resolve(favorites)
      )
    )

  favoriteDestroy: (title) ->
    new Promise((resolve, reject) ->
      _fetchFavorites()
      .then((favorites) ->
        delete favorites[title]
        store.set(Keys.FAVORITE, favorites)
        resolve(favorites)
      )
      .catch(reject)
    )

  favoriteDestroyAll: ->
    new Promise((resolve, reject) ->
      _fetchFavorites()
      .then((favorites) ->
        favorites = {}
        store.set(Keys.FAVORITE, favorites)
        resolve(favorites)
      )
      .catch(reject)
    )
