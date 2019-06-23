FROM ruby:2.6.1-alpine3.9
LABEL maintainer '8398a7 <8398a7@gmail.com>'

ENV \
  HOME=/app \
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
COPY . $HOME
COPY config/database.k8s.yml $HOME/config/database.yml
RUN mkdir log && rails ts:routes assets:precompile
