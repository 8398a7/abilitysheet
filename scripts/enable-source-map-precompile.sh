#!/bin/bash -xe

echo "module.exports.devtool = 'source-map'" >> config/webpack/production.js
echo "process.env.RELEASE = '$(git describe --tags --abbrev=10)'" >> config/webpack/production.js
RAILS_ENV=production bundle exec rails ts:routes assets:precompile

tag=$(git describe --tags --abbrev=10)
sentry-cli releases new -p ${SENTRY_PROJECT} -p abilitysheet-backend ${tag}
sentry-cli releases files ${tag} upload-sourcemaps ./public/packs/js --rewrite
sentry-cli releases finalize ${tag}
sentry-cli deploys ${tag} new -e production
