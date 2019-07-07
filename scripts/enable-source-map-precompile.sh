#!/bin/bash -xe

echo "module.exports.devtool = 'source-map'" >> config/webpack/production.js
RAILS_ENV=production rails assets:precompile
