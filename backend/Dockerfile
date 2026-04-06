FROM ruby:3.3-slim

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    libyaml-dev \
    pkg-config \
    git \
    curl \
    tzdata \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /backend

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000
CMD ["bundle","exec","rails","server","-b","0.0.0.0","-p","3000"]