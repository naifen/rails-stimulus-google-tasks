process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

environment.loaders.append('typescript', {
  test: /\.ts?$/,
  use: 'ts-loader'
})


module.exports = environment.toWebpackConfig()
