FROM ruby:3.0.2

ENV RAILS_ENV=production

RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list
RUN set -x && apt-get update -y -qq && apt-get install -yq nodejs yarn

RUN mkdir /app
WORKDIR /app
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

RUN bundle exec rails assets:precompile
RUN rm -f /app/tmp/pids/server.pid
CMD bundle exec rails s -p ${PORT:-3000} -b 0.0.0.0
