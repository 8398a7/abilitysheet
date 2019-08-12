FROM 8398a7/abilitysheet-base:latest AS base-dependencies
LABEL maintainer '8398a7 <8398a7@gmail.com>'

FROM ruby:2.6.3-alpine3.9

ENV \
  HOME=/app \
  RAILS_ENV=production \
  SECRET_KEY_BASE=wip

RUN apk add --update --no-cache \
  postgresql-client \
  tzdata \
  yarn

WORKDIR $HOME
COPY --from=base-dependencies /usr/local/bundle/ /usr/local/bundle/
COPY --from=base-dependencies $HOME/public/ $HOME/public/

COPY . $HOME
RUN \
  mv config/database.k8s.yml config/database.yml && \
  mv config/puma.k8s.rb config/puma.rb && \
  mkdir log && mkdir -p tmp/pids
