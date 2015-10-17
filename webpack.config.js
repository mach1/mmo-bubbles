module.exports = {
  entry: "./app/main.js",
  output: {
    path: __dirname + '/app',
    filename: "bundle.js"
  },
  module: {
    loaders: [
      { test: /\.coffee$/, loader: "coffee-loader" }
    ]
  }
};
