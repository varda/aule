'use strict';


var path = require('path');
var webpack = require('webpack');
var ExtractTextPlugin = require('extract-text-webpack-plugin');


// Detect if we're running webpack dev server or building a distribution.
var devServer = path.basename(require.main.filename) === 'webpack-dev-server.js';


var config = {
  plugins: [
    new webpack.IgnorePlugin(/^\.\/locale$/, /moment$/),
    new ExtractTextPlugin('styles.css'),
    new webpack.ProvidePlugin({'window.jQuery': 'jquery'})
  ],

  entry: './scripts/init.coffee',

  output: {
    filename: 'main.js',
    path: 'dist/'
  },

  resolve: {
    extensions: ['', '.js', '.coffee'],
    alias: {
      handlebars: 'handlebars/dist/handlebars'
    }
  },

  amd: {
    jQuery: true
  },

  externals: {
    config: 'AULE_CONFIG'
  },

  module: {
    preLoaders: [{
      test: /\.coffee$/,
      exclude: /node_modules/,
      loader: 'coffeelint-loader'
    }],

    loaders: [{
      test: /\.coffee$/,
      loader: 'coffee-loader'
    }, {
      test: /\.hb$/,
      loader: 'handlebars-loader?extensions=.hb&helperDirs[]=' + __dirname + '/templates/helpers'
    }, {
      test: /\.less$/,
      loader: ExtractTextPlugin.extract('style-loader', 'css-loader!less-loader')
    }, {
      test: /\.png$/,
      loader: 'url-loader?limit=10000&mimetype=image/png'
    }, {
      test: /\.woff(\?v=[0-9]\.[0-9]\.[0-9])?$/,
      loader: 'url-loader?limit=10000&mimetype=application/font-woff'
    }, {
      test: /\.woff2(\?v=[0-9]\.[0-9]\.[0-9])?$/,
      loader: 'url-loader?limit=10000&mimetype=application/font-woff2'
    }, {
      test: /\.(otf|ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
      loader: 'file-loader'
    }]
  },

  cache: false,
  debug: false,
  devtool: false
};


if (devServer) {
  config.plugins.push(
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin(),
    new webpack.DefinePlugin({'process.env.NODE_ENV': '"development"'})
  );
  config.entry = [
    'webpack/hot/only-dev-server',
    './scripts/init.coffee'
  ];
  config.devServer = {
    hot: true,
    historyApiFallback: true
  },
  config.output.publicPath = '/dist/';
  config.cache = true;
  config.debug = true;
  config.devtool = 'eval';
} else {
  config.plugins.push(
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin({compress: {drop_console: false}}),
    new webpack.optimize.OccurenceOrderPlugin(),
    new webpack.optimize.AggressiveMergingPlugin(),
    new webpack.DefinePlugin({'process.env.NODE_ENV': '"production"'})
  );
};


module.exports = config;
