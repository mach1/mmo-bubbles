webpack = require('webpack');
path = require('path');
HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  context: __dirname,
  entry: [
    'webpack-hot-middleware/client?path=/__webpack_hmr&timeout=20000&reload=true',
    "./app/main.js",
  ],
  output: {
    path: __dirname + '/build',
    publicPath: '/',
    filename: "bundle.js",
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
    }),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
  ]
};
