FROM ruby:3.0.0-slim-buster
LABEL maintainer '8398a7 <8398a7@gmail.com>'

ENV \
  HOME=/app \
  DEBIAN_FRONTEND=noninteractive \
  RAILS_ENV=production \
  SECRET_KEY_BASE=wip

WORKDIR $HOME

RUN \
  apt-get update -qq && apt-get install -y \
  git \
  build-essential \
  libpq-dev
RUN \
  apt-get install -y curl && \
  curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && apt-get install -y --no-install-recommends nodejs yarn

COPY Gemfile* $HOME/
RUN \
  bundle config set without 'development test deployment' && \
  bundle install -j4

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
COPY ./lib/ist_client.rb ./lib/rails_log_silencer.rb $HOME/lib/
COPY ./app/javascript $HOME/app/javascript
COPY ./app/controllers/application_controller.rb $HOME/app/controllers/application_controller.rb
COPY ./config $HOME/config
COPY config/database.k8s.yml $HOME/config/database.yml
ENV SENTRY_JS_DSN https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx@sentry.io/y
RUN mkdir log && rails ts:routes assets:precompile
