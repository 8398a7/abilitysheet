FROM ruby:2.6.5-alpine3.10
LABEL maintainer '8398a7 <8398a7@gmail.com>'

ENV \
  HOME=/app \
  # https://github.com/sass/sassc-ruby/issues/141
  BUNDLE_FORCE_RUBY_PLATFORM=true \
  RAILS_ENV=production \
  SECRET_KEY_BASE=wip

WORKDIR $HOME

RUN \
  apk upgrade --no-cache && \
  apk add --update --no-cache \
  build-base \
  git \
  postgresql-dev \
  ruby-dev \
  libxml2-dev \
  libxslt-dev \
  postgresql-client \
  tzdata \
  yarn

COPY Gemfile* $HOME/
RUN bundle install -j4 --without development test deployment

COPY package.json yarn.lock $HOME/
RUN yarn install
COPY ./bin $HOME/bin
COPY \
  ./Rakefile \
  ./tsconfig.json \
  ./.browserslistrc  \
  ./babel.config.js \
  ./postcss.config.js \
  $HOME/
COPY ./app/assets $HOME/app/assets
COPY ./app/models/user.rb ./app/models/application_record.rb $HOME/app/models/
COPY ./app/models/concerns/user $HOME/app/models/concerns/user
COPY ./lib/tasks/ts_routes.rake $HOME/lib/tasks/ts_routes.rake
COPY ./lib/ist_client.rb $HOME/lib/
COPY ./app/javascript $HOME/app/javascript
COPY ./app/controllers/application_controller.rb $HOME/app/controllers/application_controller.rb
COPY ./config $HOME/config
COPY config/database.k8s.yml $HOME/config/database.yml
ENV SENTRY_JS_DSN https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx@sentry.io/y
RUN mkdir log && rails ts:routes assets:precompile
