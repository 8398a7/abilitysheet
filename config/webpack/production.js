process.env.NODE_ENV = process.env.NODE_ENV || 'production';

const environment = require('./environment');

module.exports = environment.toWebpackConfig();
module.exports.devtool = 'none';
module.exports.devtool = 'source-map'
process.env.RELEASE = 'v0.0.1-15-gac7d2eeb9e'
