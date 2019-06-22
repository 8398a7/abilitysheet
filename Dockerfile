FROM ruby:2.6.1-alpine3.9 AS bundle-dependencies
LABEL maintainer '8398a7 <8398a7@gmail.com>'

ENV HOME /app

WORKDIR $HOME

COPY Gemfile* $HOME/

RUN \
  apk upgrade --no-cache && \
  apk add --update --no-cache \
    build-base \
    git \
    postgresql-dev \
    ruby-dev \
    libxml2-dev \
    libxslt-dev

RUN bundle install -j4 --without development test deployment

FROM ruby:2.6.1-alpine3.9 AS node-dependencies

ENV \
  HOME=/app \
  RAILS_ENV=production \
  SECRET_KEY_BASE=wip

RUN apk add --update --no-cache \
  postgresql-client \
  tzdata \
  yarn

COPY --from=bundle-dependencies /usr/local/bundle/ /usr/local/bundle/
WORKDIR $HOME

COPY package.json yarn.lock $HOME/
RUN yarn install
COPY . $HOME
COPY config/database.k8s.yml $HOME/config/database.yml
RUN rails ts:routes assets:precompile

FROM ruby:2.6.1-alpine3.9

ENV \
  HOME=/app \
  RAILS_ENV=production \
  SECRET_KEY_BASE=wip

RUN apk add --update --no-cache \
  postgresql-client \
  tzdata \
  yarn

WORKDIR $HOME
COPY --from=node-dependencies /usr/local/bundle/ /usr/local/bundle/
COPY --from=node-dependencies $HOME/public/ $HOME/public/

COPY . $HOME
RUN \
  mv config/database.k8s.yml config/database.yml && \
  mv config/puma.k8s.rb config/puma.rb && \
  mkdir -p tmp/pids
