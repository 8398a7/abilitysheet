const { environment } = require('@rails/webpacker')
const erb =  require('./loaders/erb')
const typescript =  require('./loaders/typescript')

environment.loaders.append('typescript', typescript)
environment.loaders.append('erb', erb)
module.exports = environment
