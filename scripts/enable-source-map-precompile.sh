#!/bin/bash -xe

echo "module.exports.devtool = 'source-map'" >> config/webpack/production.js
echo "process.env.RELEASE = 'abilitysheet@$(git describe --tags --abbrev=10)'" >> config/webpack/production.js
RAILS_ENV=production rails assets:precompile

SENTRY_PROJECT=abilitysheet-frontend
tag=$(git describe --tags --abbrev=10)
sentry-cli releases new -p ${SENTRY_PROJECT} abilitysheet@${tag}
sentry-cli releases files abilitysheet@${tag} upload-sourcemaps ./public/packs/js --rewrite
SENTRY_PROJECT=abilitysheet-frontend sentry-cli releases finalize abilitysheet@${tag}
