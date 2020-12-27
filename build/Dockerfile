FROM docker.pkg.github.com/8398a7/abilitysheet/abilitysheet-base:latest AS base-dependencies
LABEL maintainer '8398a7 <8398a7@gmail.com>'

FROM ruby:3.0.0-rc1-slim-buster

ENV \
  HOME=/app \
  RAILS_ENV=production \
  SECRET_KEY_BASE=wip

RUN \
  apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  tzdata \
  curl && \
  curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && apt-get install -y yarn

WORKDIR $HOME
COPY --from=base-dependencies /usr/local/bundle/ /usr/local/bundle/
COPY --from=base-dependencies $HOME/public/ $HOME/public/

COPY . $HOME
RUN \
  mv config/database.k8s.yml config/database.yml && \
  mkdir log && mkdir -p tmp/pids
