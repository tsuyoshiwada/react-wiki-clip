module.exports = 

  InitialKeyword: "Wikipedia"

  APIEndpoints: 
    API: "https://ja.wikipedia.org/w/api.php"
    WIKI: "https://ja.wikipedia.org/wiki/"

  APISettings:
    LIMIT: 10

  ActionTypes:
    WIKI:
      FETCH: "WIKI:FETCH"
      FETCH_SUCCESS: "WIKI:FETCH_SUCCESS"
      FETCH_FAIL: "WIKI:FETCH_FAIL"

      PAGINATE: "WIKI:PAGINATE"
      PAGINATE_SUCCESS: "WIKI:PAGINATE_SUCCESS"
      PAGINATE_FAIL: "WIKI:PAGINATE_FAIL"

      FIND: "WIKI:FIND"
      FIND_SUCCESS: "WIKI:FIND_SUCCESS"
      FIND_FAIL: "WIKI:FIND_FAIL"

      FAVORITE_SYNC: "WIKI:FAVORITE_SYNC"

      FAVORITE_FETCH: "WIKI:FAVORITE_FETCH"
      FAVORITE_FETCH_SUCCESS: "WIKI:FAVORITE_FETCH_SUCCESS"
      FAVORITE_FETCH_FAIL: "WIKI:FAVORITE_FETCH_FAIL"

      FAVORITE_ADD: "WIKI:FAVORITE_ADD"
      FAVORITE_DESTROY: "WIKI:FAVORITE_DESTROY"
      FAVORITE_DESTROY_ALL: "WIKI:FAVORITE_DESTROY_ALL"

  ErrorTypes:
    WIKI:
      NOT_FOUND: "WIKI:NOT_FOUND"
      KEYWORD_NOT_EXISTS: "WIKI:KEYWORD_NOT_EXISTS"
      FAVORITE_NOT_FOUND: "WIKI:FAVORITE_NOT_FOUND"

  SortTypes:
    ASC: "asc"
    DESC: "desc"

  ViewTypes:
    LIST: "list"
    CARD: "card"

  Path: 
    SEARCH: "/"
    ABOUT: "/about/"
    FAVORITES: "/favorites/"
    WIKI: "/wiki/:title"
