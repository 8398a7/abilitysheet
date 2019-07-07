#!/bin/bash -xe

echo "module.exports.devtool = 'source-map'" >> config/webpack/production.js
echo "process.env.RELEASE = '$(git describe --tags --abbrev=10)'" >> config/webpack/production.js
RAILS_ENV=production rails assets:precompile
