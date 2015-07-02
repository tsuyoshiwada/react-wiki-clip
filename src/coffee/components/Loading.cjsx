classNames = require("classnames")
React = require("react")


module.exports = React.createClass
  propTypes:
    show: React.PropTypes.bool

  getDefaultProps: ->
    show: false

  render: ->
    classes = classNames(
      "loading": true
      "is-show": @props.show
    )

    <div className={classes}>
      <div className="bounce1"></div>
      <div className="bounce2"></div>
      <div className="bounce3"></div>
    </div>
    