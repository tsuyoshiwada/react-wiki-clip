React = require("react")


e = (str) ->
  encodeURIComponent(str)


module.exports = React.createClass
  propTypes:
    type: React.PropTypes.string.isRequired
    url: React.PropTypes.string.isRequired
    text: React.PropTypes.string
    className: React.PropTypes.string
    target: React.PropTypes.string

  getDefaultProps: ->
    target: "_blank"

  render: ->
    url = e(@props.url)
    href = ""
    switch @props.type
      when "twitter"
        href = "https://twitter.com/share?url=#{url}"
        text = e(@props.text)
        href += "&text=#{text}" unless !@props.text
      when "facebook"
        href = "https://www.facebook.com/sharer/sharer.php?u=#{url}"

    <a
      href={href}
      className={@props.className}
      target={@props.target}>
      {@props.children}
    </a>
