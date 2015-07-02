path = require("path")
webpack = require("webpack")


module.exports = 
  progress: true
  entry: 
    app: "./src/coffee/app.cjsx"
  output:
    path: path.join(__dirname, "dist/js")
    filename: "[name].js"
  devtool: "#source-map"
  module: 
    loaders: [
      {test: /\.cjsx$/, loaders: ["coffee", "cjsx"]}
      {test: /\.coffee$/, loader: "coffee"}
    ]
  resolveLoader: 
    modulesDirectories: ["node_modules"]
  resolve: 
    extensions: ["", ".js", ".cjsx", ".coffee"]
