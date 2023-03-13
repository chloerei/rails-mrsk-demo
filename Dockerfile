### base stage ###

FROM ruby:3.2.0 AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
  libpq-dev \
  libvips42 \
  postgresql-client

RUN gem install bundler && \
  bundle config set --local path vendor/bundle

WORKDIR /rails

### CI stage ###

FROM base AS production

COPY Gemfile Gemfile.lock /rails/

RUN bundle install

COPY . /rails/

RUN bin/rails assets:precompile

ENTRYPOINT ["/rails/bin/docker-entrypoint.sh"]

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
