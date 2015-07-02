assign = require("object-assign")
{ActionTypes} = require("./constants/AppConstants")
WikiClient = require("./clients/WikiClient")


module.exports = 

  wiki: 
    fetch: (keyword) ->
      @dispatch(ActionTypes.WIKI.FETCH)

      WikiClient.fetch(keyword)
      .then((data) =>
        @dispatch(ActionTypes.WIKI.FETCH_SUCCESS, data)
      )
      .catch((error) =>
        @dispatch(ActionTypes.WIKI.FETCH_FAIL, error)
      )

    paginate: (keyword) ->
      @dispatch(ActionTypes.WIKI.PAGINATE)

      WikiClient.paginate(keyword)
      .then((data) =>
        @dispatch(ActionTypes.WIKI.PAGINATE_SUCCESS, data)
      )
      .catch((error) =>
        @dispatch(ActionTypes.WIKI.PAGINATE_FAIL, error)
      )

    find: (keyword) ->
      @dispatch(ActionTypes.WIKI.FIND)

      WikiClient.find(keyword)
      .then((data) =>
        @dispatch(ActionTypes.WIKI.FIND_SUCCESS, data)
      )
      .catch((error) =>
        @dispatch(ActionTypes.WIKI.FIND_FAIL, error)
      )

    fetchFavorites: ->
      @dispatch(ActionTypes.WIKI.FAVORITE_FETCH)

      WikiClient.fetchFavorites()
      .then((data) =>
        @dispatch(ActionTypes.WIKI.FAVORITE_FETCH_SUCCESS, data)
      )
      .catch((error) =>
        @dispatch(ActionTypes.WIKI.FAVORITE_FETCH_FAIL, error)
      )

    favoriteToggle: (wiki) ->
      if !wiki.favorite
        fav = 
          title: wiki.title
          favorite: true
          created: Date.now().toString()
        @dispatch(ActionTypes.WIKI.FAVORITE_ADD, wiki: fav)
        promise = WikiClient.favoriteAdd(fav)

      else
        @dispatch(ActionTypes.WIKI.FAVORITE_DESTROY, title: wiki.title)
        promise = WikiClient.favoriteDestroy(wiki.title)

      promise.then(@favoriteSync)

    favoriteDestroyAll: ->
      @dispatch(ActionTypes.WIKI.FAVORITE_DESTROY_ALL)
      WikiClient.favoriteDestroyAll().then(@favoriteSync)

    favoriteSync: (favorites) =>
      @dispatch(ActionTypes.WIKI.FAVORITE_SYNC, favorites: favorites)



