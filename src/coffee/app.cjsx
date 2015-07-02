React = require("react")
Router = require("react-router")
Fluxxor = require("fluxxor")

{InitialKeyword} = require("./constants/AppConstants")
WikiStore = require("./stores/WikiStore")
actions = require("./actions")
routes = require("./routes")


stores = 
  wiki: new WikiStore()

flux = new Fluxxor.Flux(stores, actions)
flux.on("dispatch", (type, payload) ->
  if console?.log
    console.log("[Dispatch]", type, payload)
)

flux.actions.wiki.fetch(InitialKeyword)

Router.run(routes, Router.HashLocation, (Root) ->
  React.render(
    <Root flux={flux} />,
    document.body
  )
)
