React = require("react")


module.exports = React.createClass
  PropTypes:
    title: React.PropTypes.string.isRequired
    icon: React.PropTypes.string
    className: React.PropTypes.string

  render: ->
    classes = (@props.className || "").split(" ")
    classes.unshift("jumbotron")
    classes = classes.join(" ")

    if @props.icon
      iconNode = <div className="jumbotron__icon"><i className={@props.icon}></i></div>

    <div className={classes}>
      <h2 className="jumbotron__title">{@props.title}</h2>
      {iconNode}
      <div className="jumbotron__body">
        {@props.children}
      </div>
    </div>