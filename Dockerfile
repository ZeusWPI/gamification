FROM ruby:2.3.8

ENV RAILS_ENV=production

RUN apt update && apt install -y nodejs cmake

WORKDIR /app

COPY ./Gemfile ./Gemfile.lock /app/

RUN gem install bundler

COPY . /app

RUN bundle install


CMD bundle exec rails s -b 0.0.0.0
