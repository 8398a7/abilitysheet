FROM ruby:2.4.0

RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs apt-transport-https
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq && apt-get install -y yarn

RUN mkdir /abilitysheet
WORKDIR /abilitysheet

COPY Gemfile /abilitysheet/Gemfile
COPY Gemfile.lock /abilitysheet/Gemfile.lock

RUN bundle install -j4
COPY yarn.lock /abilitysheet/yarn.lock
COPY . /abilitysheet
RUN rm /abilitysheet/config/database.yml
COPY config/database.docker.yml /abilitysheet/config/database.yml
RUN rake assets_rails:install assets_rails:resolve assets:precompile
RUN mkdir -p tmp/pids && mkdir tmp/sockets
