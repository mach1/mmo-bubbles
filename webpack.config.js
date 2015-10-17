HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  entry: "./app/main.js",
  output: {
    path: __dirname + '/dist',
    filename: "bundle.js"
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee-loader" }
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './app/index.html',
      inject: 'body'
    })
  ]
};
