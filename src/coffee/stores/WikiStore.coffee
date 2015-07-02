_ = require("underscore")
assign = require("object-assign")
Fluxxor = require("fluxxor")
{APISettings, ActionTypes, SortTypes, InitialKeyword} = require("../constants/AppConstants")


CHANGE_EVENT = "change"


_favoriteByTitle = (wikis, title) ->
  wiki = _.findWhere(wikis, title: title)
  wiki?.favorite = true


_undoFavoriteByTitle = (wikis, title) ->
  wiki = _.findWhere(wikis, title: title)
  wiki?.favorite = false


_favoriteAll = (wikis, favorites) ->
  _.each(favorites, (fav) ->
    _favoriteByTitle(wikis, fav.title)
  )


_undoFavoriteAll = (wikis) ->
  _.each(wikis, (wiki) ->
    wiki.favorite = false
  )


module.exports = Fluxxor.createStore
  initialize: ->
    @wikis = []
    @wiki = null
    @keyword = InitialKeyword
    @content = ""
    @total = 0
    @page = 0
    @last = false

    @favorites = {}
    @favoriteSort = SortTypes.ASC

    @loading = false
    @error = false

    @bindActions(
      ActionTypes.WIKI.FETCH, @handleFetch,
      ActionTypes.WIKI.FETCH_SUCCESS, @handleFetchSuccess,
      ActionTypes.WIKI.FETCH_FAIL, @handleFetchFail,

      ActionTypes.WIKI.PAGINATE, @handlePaginate,
      ActionTypes.WIKI.PAGINATE_SUCCESS, @handlePaginateSuccess,
      ActionTypes.WIKI.PAGINATE_FAIL, @handlePaginateFail,

      ActionTypes.WIKI.FIND, @handleFind,
      ActionTypes.WIKI.FIND_SUCCESS, @handleFindSuccess,
      ActionTypes.WIKI.FIND_FAIL, @handleFindFail,

      ActionTypes.WIKI.FAVORITE_FETCH, @handleFavoriteFetch,
      ActionTypes.WIKI.FAVORITE_FETCH_SUCCESS, @handleFavoriteFetchSuccess,
      ActionTypes.WIKI.FAVORITE_FETCH_FAIL, @handleFavoriteFetchFail,

      ActionTypes.WIKI.FAVORITE_ADD, @handleFavoriteAdd,
      ActionTypes.WIKI.FAVORITE_DESTROY, @handleFavoriteDestroy,
      ActionTypes.WIKI.FAVORITE_DESTROY_ALL, @handleFavoriteDestroyAll,

      ActionTypes.WIKI.FAVORITE_SYNC, @handleFavoriteSync,
    )

  getState: ->
    wikis: @wikis
    wiki: @wiki
    favorites: @favorites
    keyword: @keyword
    content: @content
    total: @total
    page: @page
    loading: @loading
    last: @last
    error: @error

  # =================================================
  # Fetch
  # =================================================
  handleFetch: (payload) ->
    @wikis = []
    @total = 0
    @loading = true
    @last = false
    @emit(CHANGE_EVENT)

  handleFetchSuccess: (payload) ->
    @wikis = payload.wikis
    @keyword = payload.keyword
    @total = payload.total
    @page = payload.page
    @loading = false
    @error = false

    _favoriteAll(@wikis, @favorites)

    @emit(CHANGE_EVENT)

  handleFetchFail: (payload) ->
    @loading = false
    @keyword = ""
    @error = payload.error
    @emit(CHANGE_EVENT)

  # =================================================
  # Paginate
  # =================================================
  handlePaginate: (payload) ->
    @loading = true
    @emit(CHANGE_EVENT)

  handlePaginateSuccess: (payload) ->
    wikis = payload.wikis
    _favoriteAll(wikis, @favorites)

    @wikis = @wikis.concat(wikis)
    @loading = false
    @page = payload.page
    @last = payload.total <= APISettings.LIMIT * payload.page
    @error = false
    @emit(CHANGE_EVENT)

  handlePaginateFail: (payload) ->
    @loading = false
    @error = payload.error
    @emit(CHANGE_EVENT)

  # =================================================
  # Find
  # =================================================
  handleFind: (payload) ->
    @loading = true
    @wiki = null
    @content = ""
    @emit(CHANGE_EVENT)

  handleFindSuccess: (payload) ->
    @loading = false
    @wiki = payload.wiki
    @emit(CHANGE_EVENT)

  handleFindFail: (payload) ->
    @loading = false
    @error = payload.error
    @emit(CHANGE_EVENT)

  # =================================================
  # Favorite Fetch
  # =================================================
  handleFavoriteFetch: (payload) ->
    @favorites = []
    @loading = true
    @emit(CHANGE_EVENT)

  handleFavoriteFetchSuccess: (payload) ->
    @favorites = payload.favorites
    @loading = false
    @emit(CHANGE_EVENT)

  handleFavoriteFetchFail: (payload) ->
    @loading = false
    @error = payload.error
    @emit(CHANGE_EVENT)

  # =================================================
  # Favorite other operation
  # =================================================
  handleFavoriteAdd: (payload) ->
    @favorites[payload.wiki.title] = payload.wiki
    _favoriteByTitle(@wikis, payload.wiki.title)
    @emit(CHANGE_EVENT)

  handleFavoriteDestroy: (payload) ->
    delete @favorites[payload.title]
    _undoFavoriteByTitle(@wikis, payload.title)
    @emit(CHANGE_EVENT)

  handleFavoriteDestroyAll: (payload) ->
    @favorites = {}
    _undoFavoriteAll(@wikis)
    @emit(CHANGE_EVENT)

  handleFavoriteSortToggle: (payload) ->
    # @todo

  handleFavoriteSync: (payload) ->
    @favorites = payload.favorites
    @emit(CHANGE_EVENT)

