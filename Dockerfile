FROM ruby:3.3.0-alpine
RUN apk add --no-cache build-base linux-headers
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
