FROM ruby:3.3.6-slim AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4

FROM ruby:3.3.6-slim
WORKDIR /app
RUN groupadd -r appuser && useradd -r -g appuser -u 1001 appuser
COPY --from=builder /app/.bundle ./.bundle
COPY --from=builder /app/vendor ./vendor
COPY Gemfile Gemfile.lock ./
COPY . .
RUN bundle config set --local deployment 'true' && \
    bundle config set --local without 'development test'
EXPOSE 3000
USER 1001
CMD ["bundle", "exec", "rackup", "-o", "0.0.0.0", "-p", "3000"]