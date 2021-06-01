FROM ruby:2.7.1-alpine AS base

ENV INSTALL_PATH /app

RUN apk add --update \
  postgresql-dev \
  tzdata

FROM base AS dependencies

RUN apk add --update build-base

COPY Gemfile Gemfile.lock ./

RUN bundle check || bundle install 

FROM base

WORKDIR $INSTALL_PATH

COPY --from=dependencies /usr/local/bundle/ /usr/local/bundle/

COPY . $INSTALL_PATH

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
